# Spec Delta

## Purpose

Permite que os quatro perfis de prestador criem seus itens de catálogo localmente por formulários claros, validados e alinhados à identidade visual do aplicativo.

## ADDED Requirements

### Requirement: Acesso e conclusão do cadastro de catálogo
O sistema SHALL abrir o formulário específico ao acionar o botão principal de cadastro no painel de barqueiro, guia, artesã ou cozinheira. Após uma confirmação válida, SHALL salvar o item localmente, retornar ao painel de origem e comunicar o sucesso; cancelar SHALL descartar somente dados ainda não confirmados.

#### Scenario: Prestador conclui um cadastro válido
- **WHEN** o usuário preenche os campos obrigatórios e confirma o formulário
- **THEN** o item é persistido uma única vez e passa a aparecer no painel correspondente

#### Scenario: Prestador cancela o cadastro
- **WHEN** o usuário volta sem confirmar o formulário
- **THEN** nenhum novo item é incluído no catálogo local

### Requirement: Cadastro de saída de barco
O formulário de saída de barco SHALL coletar embarcação, origem, destino, horário de partida, lotação máxima e valor por assento. SHALL oferecer ajuste rápido do horário e um contador para a lotação, iniciar as reservas em zero e rejeitar origem/destino vazios, lotação menor que um, horário inválido ou preço não positivo.

#### Scenario: Barqueiro confirma uma saída
- **WHEN** o barqueiro informa uma rota válida, horário, lotação e preço e confirma a saída
- **THEN** o painel passa a listar a rota, a partida, a capacidade e o preço com zero vagas reservadas

#### Scenario: Barqueiro informa valores inválidos
- **WHEN** o barqueiro tenta confirmar sem trecho completo, com lotação zero, horário inválido ou preço zero/negativo
- **THEN** o formulário destaca os campos inválidos e não grava a saída

### Requirement: Cadastro de trilha
O formulário de trilha SHALL coletar nome, nível, duração, coordenadas GPS e limite de pessoas. SHALL oferecer exclusivamente os níveis Leve, Moderada e Selva Densa, destacar a seleção ativa e oferecer uma ação de captura simulada de GPS. Nome, duração e limite inválidos SHALL impedir a publicação; coordenadas ainda não capturadas SHALL ser identificadas como tal no registro.

#### Scenario: Guia publica uma trilha com localização
- **WHEN** o guia informa os dados válidos, seleciona um nível e obtém ou preenche coordenadas GPS
- **THEN** a trilha é publicada no catálogo local com todos os dados informados

#### Scenario: Guia publica sem capturar coordenadas
- **WHEN** o guia confirma uma trilha válida sem acionar a captura de GPS
- **THEN** a trilha é publicada com as coordenadas identificadas como não capturadas

### Requirement: Cadastro de peça de artesanato
O formulário de artesanato SHALL permitir anexar ou capturar uma imagem, informar o nome, selecionar Sementes Naturais, Madeira Caída ou Fibra de Arumã, definir a quantidade e informar o preço. SHALL exigir nome, matéria-prima, quantidade mínima de uma unidade e preço positivo; quando não houver imagem capturada ou anexada, SHALL associar uma imagem-padrão local à peça.

#### Scenario: Artesã publica uma peça fotografada
- **WHEN** a artesã anexa uma imagem e confirma os demais dados válidos
- **THEN** a vitrine exibe a imagem, nome, matéria-prima, estoque e preço da nova peça

#### Scenario: Artesã publica sem fotografia
- **WHEN** a artesã confirma uma peça válida sem anexar ou capturar uma imagem
- **THEN** a vitrine apresenta a peça com a imagem-padrão local

### Requirement: Cadastro de refeição
O formulário de refeição SHALL coletar tipo, nome do prato, início e fim da janela de atendimento, limite de porções e preço. SHALL oferecer exclusivamente os tipos Café Regional, Almoço da Floresta e Merenda, iniciar as reservas em zero e rejeitar tipo não selecionado, prato vazio, janela inválida, limite menor que uma porção ou preço não positivo.

#### Scenario: Cozinheira salva um cardápio
- **WHEN** a cozinheira confirma uma refeição com tipo, prato, janela, limite e preço válidos
- **THEN** o cardápio local apresenta a refeição com zero porções reservadas

#### Scenario: Cozinheira informa fim anterior ao início
- **WHEN** a cozinheira tenta confirmar uma janela cujo horário final não é posterior ao inicial
- **THEN** o formulário informa que a janela é inválida e não grava a refeição

### Requirement: Feedback de gravação indisponível
O sistema SHALL manter os valores preenchidos no formulário e informar uma falha compreensível quando não conseguir concluir a gravação local, sem navegar para o painel como se o cadastro tivesse sido salvo.

#### Scenario: Falha ao gravar localmente
- **WHEN** a gravação do item retorna erro
- **THEN** o formulário permanece aberto com os dados preenchidos e apresenta uma mensagem de erro
