# Design

## Context

O app Flutter inicia diretamente em `LoginView`, que hoje chama somente `POST /api/login` por meio de `ApiService` e apenas mostra um aviso de sucesso. A API Laravel possui uma rota de login com Sanctum, um único modelo `User` e a tabela padrão `users`; não há cadastro, perfis especializados nem homes Flutter existentes. Veja `proposal.md` e a especificação `identity/user-registration` para o comportamento exigido.

## Goals / Non-Goals

**Goals:**

- Criar uma jornada de cadastro responsiva e validada para os cinco perfis.
- Mapear a identidade comum para `User` e os comportamentos de Turista e Prestador para perfis 1:1 persistidos em uma única transação.
- Estabelecer uma resposta de autenticação de cadastro estável para o Flutter, com token, tipo de perfil e situação de homologação.
- Direcionar o novo usuário para uma home Flutter contextual e manter o token de forma segura para requisições autenticadas subsequentes.

**Non-Goals:**

- Construir a fila, interface administrativa ou decisão humana de homologação.
- Criar coleta de documentos, upload de arquivos, recuperação de senha, login social ou sincronização offline.
- Alterar cadastros legados que ainda não possuam perfil; a migração será aditiva e o novo endpoint preencherá os dados para novas contas.

## Decisions

### Perfis normalizados sobre uma identidade comum

Será mantida uma tabela `users` como raiz, com `profile_type` armazenado como `string` validada pela aplicação (`turista`, `barqueiro`, `guia`, `artesa`, `cozinheira`). Serão adicionadas as relações 1:1:

- `tourist_profiles`: `user_id` único e `travel_preferences` JSON;
- `provider_profiles`: `user_id` único, `phone`, `service_description`, `professional_metadata` JSON e `verified` boolean com padrão `false`.

Os quatro tipos de prestador compartilham a mesma estrutura e são distinguidos por `users.profile_type`; isso representa a especialização de `Prestador` sem duplicar quatro tabelas idênticas. A persistência será envolvida em uma transação para que usuário e perfil sejam criados juntos.

Alternativas consideradas: incluir todos os campos em `users` criaria muitas colunas irrelevantes e nulas; criar uma tabela para cada profissão repetiria a mesma estrutura e dificultaria a evolução de campos compartilhados. Um enum nativo foi descartado porque um `string` validado evita uma migração de tipo para acrescentar outro perfil futuramente.

### Contrato único de registro e resposta de sessão

`POST /api/register` receberá `name`, `email`, `password`, `profile_type` e apenas os campos condicionais do perfil. Para Turista, `travel_preferences` será obrigatório; para prestadores, `phone`, `service_description` e o objeto não vazio `professional_metadata` serão obrigatórios. A validação ficará em uma Form Request, e um controlador dedicado criará a conta, o perfil e o token Sanctum.

Em sucesso, a rota responderá `201` com `user` (id, nome, e-mail, `profile_type` e `verified` para prestadores) e `token`, sem senha. Erros de regra de negócio e de entrada usarão a estrutura de erro de validação Laravel (`422`), incluindo e-mail duplicado. Isso mantém o contrato paralelo ao login atual e permite ao Flutter exibir erros por campo.

Alternativa considerada: reutilizar a closure em `routes/api.php`. Um controlador e uma Form Request separam regras condicionais, transação e serialização do arquivo de rotas, que já contém o login mínimo.

### Fluxo Flutter orientado por formulário e sessão

`LoginView` ganhará uma ação para abrir `RegistrationView`. A nova tela usará `Form` e campos controlados; os dados comuns permanecem ao trocar de opção, enquanto a seção condicional é renderizada para Turista ou para cada especialidade de prestador. O serviço HTTP receberá um payload/resultado tipado de cadastro, reaproveitando base URL, timeout e headers existentes.

Após uma resposta válida, uma abstração de sessão gravará o token Sanctum com armazenamento seguro e encaminhará à home contextual. Como o app não possui homes implementadas, esta entrega introduzirá uma home de entrada reutilizável que recebe o perfil e mostra a especialidade; para prestadores pendentes ela inclui o aviso de homologação. A navegação será substitutiva, para que voltar não reabra o formulário de cadastro.

Alternativa considerada: guardar o token apenas em memória e usar uma única confirmação por SnackBar. Isso perderia o estado em reinicializações e não atenderia ao redirecionamento após cadastro. Uma home diferente e completa para cada profissão também foi descartada por não haver navegação ou funcionalidade de domínio Flutter existente para suportá-la.

### Compatibilidade de banco e exposição de dados

As migrações usarão tipos Laravel portáveis (`json` para os campos estruturados), que são executáveis no SQLite de testes e no PostgreSQL configurado no ambiente. A conexão de produção deverá usar `DB_CONNECTION=pgsql` e credenciais PostgreSQL; nenhuma credencial será incluída no repositório. A resposta utilizará uma representação pública do usuário, garantindo que `password`, `remember_token` e metadados que não devam ser públicos não sejam serializados.

## Risks / Trade-offs

- [Os detalhes internos dos metadados de homologação ainda não foram definidos] → aceitar um objeto JSON não vazio agora e manter o campo extensível; requisitos documentais específicos serão uma mudança posterior.
- [A migração aditiva deixa contas legadas sem `profile_type`] → as novas contas sempre terão perfil; futuras alterações ao login ou migração de legados deverão definir um caminho de atualização explícito.
- [O status pendente pode ser confundido com bloqueio de acesso] → a home de prestador exibirá claramente que a conta está autenticada, mas a homologação continua pendente.
- [Armazenamento de token exige suporte nativo por plataforma] → encapsular o acesso ao armazenamento e cobri-lo com doubles nos testes de widget/serviço.

## Migration Plan

1. Aplicar as migrações aditivas de perfil no ambiente PostgreSQL e confirmar índices únicos de `user_id` e `email`.
2. Publicar o endpoint de cadastro com testes de integração antes de disponibilizar a tela Flutter.
3. Publicar o app com o novo fluxo; novos cadastros passarão a receber `profile_type` e, para prestadores, `verified=false`.
4. Em caso de rollback da aplicação, a alteração de banco pode permanecer sem afetar login existente. Reverter dados somente por migração reversível antes de haver cadastros dependentes ou por plano de retenção aprovado.

## Open Questions

- A definição de quais chaves compõem `professional_metadata` pode ser refinada pelo processo administrativo futuro sem alterar o contrato atual de objeto obrigatório.
