# Spec Delta

## Purpose

Disponibilizar ao turista um catálogo responsivo para descobrir experiências comunitárias amazônicas e refinar os resultados sem perder o acesso às áreas principais do perfil.

## ADDED Requirements

### Requirement: Tela Explorar do turista
O sistema SHALL apresentar ao turista uma tela Explorar com a localização “RDS Rio Negro, AM”, indicador “Online”, busca “Buscar experiências...” e filtros horizontais Todos, Barcos Fluviais, Trilhas na Selva, Artesanato e Culinária.

#### Scenario: Abertura do catálogo turístico
- **WHEN** uma sessão autenticada de turista abre sua área inicial
- **THEN** o sistema mostra a tela Explorar com “Todos” selecionado e a localização, status, busca e filtros visíveis

### Requirement: Busca e filtros de experiências
O sistema SHALL filtrar as experiências exibidas pela categoria selecionada e pelo texto de busca, considerando título e nome do anfitrião sem diferenciar maiúsculas de minúsculas.

#### Scenario: Filtro por categoria
- **WHEN** o turista seleciona “Trilhas na Selva”
- **THEN** o sistema mostra somente experiências classificadas como trilhas e destaca o filtro selecionado

#### Scenario: Busca por anfitrião
- **WHEN** o turista informa um trecho do nome de um anfitrião na busca
- **THEN** o sistema mostra somente experiências cujo título ou anfitrião contém o trecho informado

#### Scenario: Busca sem resultados
- **WHEN** os filtros ativos não encontram experiências
- **THEN** o sistema informa que nenhuma experiência foi encontrada

### Requirement: Cards de experiência comunitária
O sistema SHALL apresentar cada experiência filtrada em um card com imagem, avaliação, comunidade/localidade, título, anfitrião, preço com unidade e total de avaliações. A indisponibilidade de uma imagem SHALL preservar a legibilidade do card por meio de um estado visual alternativo.

#### Scenario: Card de travessia fluvial
- **WHEN** o catálogo é apresentado sem filtros restritivos
- **THEN** o sistema exibe “Travessia dos Botos & Vivência Comunitária no Tumbira”, Seu Raimundo Nonato, comunidade do Tumbira, avaliação 4.9, R$ 120 por participante e 42 avaliações

### Requirement: Navegação inferior do turista
O sistema SHALL manter uma navegação inferior fixa na tela Explorar contendo Explorar, Passaporte, Meu Voucher e Perfil, com Explorar destacado como item ativo.

#### Scenario: Catálogo longo com navegação disponível
- **WHEN** a lista de experiências exige rolagem vertical
- **THEN** a navegação inferior continua disponível sem ocultar o último conteúdo rolável

### Requirement: Uso responsivo e acessível do catálogo
O sistema SHALL manter o catálogo utilizável entre 320 e 1024 pixels lógicos de largura, sem rolagem horizontal da página, com rolagem horizontal apenas na faixa de filtros quando necessária e alvos de toque de pelo menos 44 pixels lógicos.

#### Scenario: Tela compacta
- **WHEN** a tela Explorar é renderizada com 320 pixels lógicos de largura
- **THEN** os cards permanecem legíveis, a página não transborda horizontalmente e filtros adicionais podem ser alcançados por rolagem horizontal
