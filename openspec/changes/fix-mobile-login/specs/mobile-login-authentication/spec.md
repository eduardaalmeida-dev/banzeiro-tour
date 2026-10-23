# Spec Delta

## Purpose

Permitir que o aplicativo móvel autentique usuários no Laravel e apresente falhas de login de forma acionável e segura.

## ADDED Requirements

### Requirement: Endpoint de login da API está disponível
O backend SHALL disponibilizar `POST /api/login`, aceitar um corpo JSON com `email` e `password`, e emitir um token Sanctum para credenciais válidas. Credenciais inválidas MUST retornar 401 em JSON, e campos ausentes ou inválidos MUST retornar 422 em JSON.

#### Scenario: Credenciais válidas
- **WHEN** a API recebe um e-mail cadastrado e sua senha correta
- **THEN** ela retorna 200 com o usuário autenticado e um token de acesso

#### Scenario: Credenciais inválidas
- **WHEN** a API recebe e-mail inexistente ou senha incorreta
- **THEN** ela retorna 401 com uma mensagem de credenciais inválidas

#### Scenario: Corpo de login inválido
- **WHEN** a API recebe e-mail inválido ou não recebe um dos campos obrigatórios
- **THEN** ela retorna 422 em JSON descrevendo os campos inválidos

### Requirement: Destino da API é configurável por compilação
O aplicativo SHALL usar uma URL base de API configurável por `API_BASE_URL` em tempo de compilação. Sem essa configuração, a compilação Android para emulador MUST preservar `http://10.0.2.2:8000/api` como destino de desenvolvimento, permitindo que dispositivos físicos e ambientes publicados forneçam outra URL sem edição do código.

#### Scenario: Execução no emulador sem configuração adicional
- **WHEN** o aplicativo Android é executado sem `API_BASE_URL`
- **THEN** a solicitação de login é enviada para `http://10.0.2.2:8000/api/login`

#### Scenario: Execução em destino configurado
- **WHEN** a compilação define `API_BASE_URL` para um servidor acessível
- **THEN** a solicitação de login usa essa URL base sem alteração de código-fonte

### Requirement: Android permite conexões da API
O manifesto principal do Android MUST declarar a permissão de acesso à internet para que variantes de depuração, perfil e release possam realizar solicitações à API. As compilações de desenvolvimento MUST continuar permitindo HTTP para o servidor local configurado.

#### Scenario: Compilação release com API acessível
- **WHEN** uma variante release é instalada com uma URL de API acessível
- **THEN** o sistema operacional permite que o aplicativo inicie a solicitação de login

### Requirement: Resultado do login é comunicado corretamente
O aplicativo SHALL distinguir sucesso, credenciais inválidas, resposta inválida da API e falha de conexão ao comunicar o resultado ao usuário. Ele MUST preservar a mensagem de boas-vindas no sucesso e MUST NOT registrar ou exibir senha, token ou corpo completo de resposta.

#### Scenario: Login bem-sucedido
- **WHEN** a API retorna 200 com usuário autenticado
- **THEN** o aplicativo exibe a mensagem de boas-vindas com o nome do usuário

#### Scenario: Credenciais recusadas
- **WHEN** a API retorna 401
- **THEN** o aplicativo informa que o e-mail ou a senha estão incorretos

#### Scenario: API indisponível ou inacessível
- **WHEN** não há conexão com o servidor configurado ou a solicitação expira
- **THEN** o aplicativo informa que não foi possível conectar ao servidor

#### Scenario: Falha de validação ou serviço
- **WHEN** a API retorna uma resposta não bem-sucedida diferente de 401
- **THEN** o aplicativo informa que não foi possível concluir o login e permite nova tentativa
