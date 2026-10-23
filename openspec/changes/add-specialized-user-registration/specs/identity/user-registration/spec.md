# Spec Delta

## Purpose

Permitir que turistas e prestadores comunitários criem uma conta especializada, sejam autenticados imediatamente e tenham seu perfil de atuação identificado pelo Banzeiro Tour.

## ADDED Requirements

### Requirement: Entrada de cadastro e seleção de perfil
O sistema SHALL disponibilizar uma ação “Cadastre-se” a partir do login e permitir que a pessoa escolha exatamente um perfil entre Turista, Barqueiro, Guia, Artesã e Cozinheira antes de finalizar o cadastro.

#### Scenario: Exibição dos cinco perfis elegíveis
- **WHEN** a pessoa abre o fluxo de cadastro a partir da tela de login
- **THEN** o sistema apresenta as opções Turista, Barqueiro, Guia, Artesã e Cozinheira para seleção

#### Scenario: Troca de perfil durante o preenchimento
- **WHEN** a pessoa seleciona um perfil diferente antes de enviar o formulário
- **THEN** o sistema atualiza os campos específicos para o perfil recém-selecionado e preserva os campos base já preenchidos

### Requirement: Coleta condicional e validação no cliente
O sistema SHALL exigir nome completo, e-mail e senha para todos os perfis; Turista SHALL informar preferências de viagem; e Barqueiro, Guia, Artesã e Cozinheira SHALL informar telefone, descrição do serviço e metadados profissionais de homologação antes do envio.

#### Scenario: Cadastro válido de turista
- **WHEN** a pessoa seleciona Turista e preenche todos os campos base e as preferências de viagem
- **THEN** o sistema permite o envio do cadastro sem solicitar dados de prestador

#### Scenario: Tentativa de envio de prestador incompleta
- **WHEN** um perfil de prestador não possui telefone, descrição do serviço ou metadados profissionais de homologação
- **THEN** o sistema bloqueia o envio e informa quais campos obrigatórios precisam ser corrigidos

### Requirement: Contrato de registro especializado
O sistema SHALL aceitar um registro especializado em `POST /api/register` contendo os dados base, o perfil selecionado e os dados condicionais do perfil, validando o e-mail como único e recusando valores de perfil ou dados obrigatórios inválidos sem criar uma conta parcial.

#### Scenario: E-mail já cadastrado
- **WHEN** `POST /api/register` recebe um e-mail que pertence a uma conta existente
- **THEN** o sistema responde com erro de validação identificando o e-mail e não cria outro usuário ou perfil

#### Scenario: Perfil não suportado
- **WHEN** `POST /api/register` recebe um perfil diferente de Turista, Barqueiro, Guia, Artesã ou Cozinheira
- **THEN** o sistema responde com erro de validação identificando o perfil inválido e não persiste dados

### Requirement: Persistência de usuário e perfil especializado
O sistema SHALL persistir os dados comuns da pessoa e associá-los a um único perfil de turista ou de prestador compatível com o perfil selecionado. Todo novo prestador SHALL iniciar com o estado de verificação pendente (`verificado = false`).

#### Scenario: Criação de turista
- **WHEN** um cadastro Turista válido é aceito
- **THEN** o sistema cria a conta e o perfil de turista com as preferências de viagem informadas

#### Scenario: Criação de prestador pendente
- **WHEN** um cadastro válido de Barqueiro, Guia, Artesã ou Cozinheira é aceito
- **THEN** o sistema cria a conta e o perfil de prestador com os dados profissionais informados e `verificado` igual a `false`

### Requirement: Autenticação e direcionamento após o cadastro
O sistema SHALL responder a um cadastro bem-sucedido com um token de acesso Sanctum e os dados públicos da conta, incluindo perfil e estado de verificação quando aplicável. O cliente SHALL abrir a home correspondente ao perfil e indicar que o prestador aguarda homologação quando estiver pendente.

#### Scenario: Resposta de cadastro bem-sucedido
- **WHEN** `POST /api/register` conclui a criação de uma conta
- **THEN** a resposta contém os dados públicos da conta, o perfil selecionado e um token de acesso não vazio, sem expor a senha

#### Scenario: Prestador autenticado com homologação pendente
- **WHEN** o cadastro de um prestador retorna `verificado = false`
- **THEN** o cliente autentica a pessoa, abre sua home de prestador e apresenta o estado de homologação pendente
