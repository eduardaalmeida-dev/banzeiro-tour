# Tasks

## 1. Persistência e API de cadastro

- [x] 1.1 Preparar o ambiente Laravel conforme `api/AGENTS.md` (instalar/configurar Laravel Boost e reler as diretrizes geradas) e verificar que o comando de instalação conclui em `api/`.
- [x] 1.2 Criar migrações aditivas para `profile_type`, `tourist_profiles` e `provider_profiles`, com relações, índices únicos, colunas JSON e `verified` padrão `false`; verificar aplicando `php artisan migrate` em PostgreSQL configurado e na base de testes.
- [x] 1.3 Criar os modelos e relações de perfil com casts, atributos públicos seguros e suporte aos cinco valores de `profile_type`; verificar com testes de modelo ou feature que Turista e cada tipo de prestador podem ser associados ao usuário correto.
- [x] 1.4 Implementar Form Request, controlador e rota `POST /api/register` com validação condicional, transação e emissão Sanctum; verificar com testes de feature os cadastros válidos de Turista e de cada especialidade de prestador.
- [x] 1.5 Cobrir na suíte de feature as respostas `201`, token e dados públicos, `verified=false` de prestador, e erros `422` para e-mail duplicado, perfil inválido e campos condicionais ausentes; verificar com `php artisan test --filter=RegistrationTest` em `api/`.
- [x] 1.6 Documentar em `api/README.md` o payload, a resposta e as variáveis de conexão PostgreSQL de `POST /api/register`; verificar que os exemplos não incluem senha em respostas nem credenciais reais.

## 2. Sessão e contrato HTTP Flutter

- [x] 2.1 Adicionar armazenamento seguro e uma abstração injetável de sessão para o token Sanctum, incluindo a configuração necessária por plataforma; verificar com testes unitários usando um armazenamento falso, sem acessar o armazenamento nativo.
- [x] 2.2 Adicionar tipos de payload e resultado de cadastro ao cliente API e implementar o `POST /register` com headers, timeout e interpretação de sucesso, validação e falha de rede; verificar com testes `MockClient` para `201`, `422` e exceção de conexão.
- [x] 2.3 Garantir que o resultado de cadastro exponha perfil e verificação somente a partir dos dados públicos retornados pela API; verificar que nenhuma serialização de requisição ou estado de sessão registra senha em testes.

## 3. Jornada de cadastro e home contextual

- [x] 3.1 Adicionar a ação “Cadastre-se” à `LoginView` e implementar `RegistrationView` com seleção de Turista, Barqueiro, Guia, Artesã e Cozinheira; verificar em teste de widget que as cinco opções podem ser selecionadas e que os campos base são preservados na troca.
- [x] 3.2 Implementar os campos condicionais e as mensagens de validação do formulário: preferências para Turista e telefone, descrição e metadados profissionais para prestadores; verificar em testes de widget que cada perfil bloqueia submissões incompletas e permite uma submissão válida.
- [x] 3.3 Conectar o envio ao cliente API, exibir erros retornados por campo e impedir envios repetidos enquanto a requisição estiver em andamento; verificar em teste de widget os estados de carregamento, validação da API e falha de rede.
- [x] 3.4 Criar a home de entrada contextual e navegar de forma substitutiva após salvar a sessão; verificar em teste de widget que o perfil exibido corresponde à resposta e que um prestador com `verified=false` vê o aviso de homologação pendente.

## 4. Verificação integrada

- [x] 4.1 Executar `php artisan test` em `api/` e `flutter test` na raiz, corrigindo regressões nas suítes de login e cadastro até ambas passarem.
- [x] 4.2 Executar `flutter analyze` e `dart format --set-exit-if-changed lib test`, corrigindo análises e formatação pendentes; verificar que os comandos terminam sem erros.
- [x] 4.3 Validar o contrato OpenSpec final com `openspec validate --change add-specialized-user-registration --strict`; verificar que a mudança permanece válida antes da revisão.

## Workflow follow-up

- Após a revisão e a implementação concluída, arquivar a mudança pelo fluxo OpenSpec apropriado.
