# Tasks

## 1. Endpoint Laravel de autenticação

- [x] 1.1 Registrar `routes/api.php` no bootstrap do Laravel e corrigir sua abertura PHP, verificando que `php artisan route:list --path=api/login --json` lista `POST api/login`.
- [x] 1.2 Criar testes de feature para login válido, credenciais inválidas e carga inválida usando o banco SQLite em memória, verificando que `php artisan test --filter=Login` passa e que a resposta bem-sucedida não expõe a senha.

## 2. Conectividade e cliente Flutter

- [x] 2.1 Declarar `android.permission.INTERNET` no manifest principal sem remover o suporte HTTP local, verificando que o manifesto mesclado de uma variante release contém a permissão.
- [ ] 2.2 Configurar `API_BASE_URL` por `--dart-define`, com padrão do emulador e normalização de barra final, verificando em teste unitário que as URLs padrão e configurada terminam em `/login` corretamente.
- [ ] 2.3 Substituir o retorno anulável por resultados tipados e cliente HTTP injetável, removendo logs de corpo de resposta, verificando em testes unitários o mapeamento de 200, 401, 422/5xx e exceção de rede.

## 3. Feedback de login e documentação de desenvolvimento

- [ ] 3.1 Atualizar a tela de login para tratar cada resultado tipado, verificando em widget tests a saudação de sucesso e mensagens distintas para credenciais, servidor inacessível e falha de serviço.
- [x] 3.2 Documentar no README como iniciar o Laravel, usar o emulador e informar `API_BASE_URL` em dispositivo físico ou ambiente publicado, verificando que os comandos e URLs documentados correspondem à configuração implementada.

## 4. Verificação integrada

- [ ] 4.1 Executar as suítes Laravel e Flutter (`php artisan test`, `flutter analyze` e `flutter test`), verificando que todas concluem sem falhas relacionadas ao login.
- [ ] 4.2 Com o Laravel em execução, testar manualmente o login no emulador com uma conta existente, verificando a resposta 200 e a mensagem de boas-vindas no aplicativo.
