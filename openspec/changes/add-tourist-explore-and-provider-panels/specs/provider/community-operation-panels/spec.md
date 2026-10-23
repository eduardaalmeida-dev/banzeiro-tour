# Spec Delta

## Purpose

Oferecer a cada prestador comunitário um painel responsivo que comunique sua operação diária, seus itens publicados e os controles locais definidos pelos protótipos Banzeiro Tour.

## ADDED Requirements

### Requirement: Destino inicial por perfil autenticado
O sistema SHALL abrir a área inicial correspondente ao perfil autenticado: Explorar para Turista; Painel do Barqueiro, Guia, Artesã ou Cozinheira para os respectivos prestadores, quando a identidade da sessão informar um perfil reconhecido.

#### Scenario: Guia autenticado
- **WHEN** a sessão autenticada informa o perfil Guia
- **THEN** o sistema apresenta o Painel do Guia como área inicial

#### Scenario: Perfil indisponível na resposta de login
- **WHEN** uma resposta de login não informa um perfil reconhecido
- **THEN** o sistema preserva o comportamento autenticado atual e não encerra a sessão por causa da ausência desse campo

### Requirement: Painel do Barqueiro
O sistema SHALL apresentar o Painel do Barqueiro com o perfil de Seu Raimundo Nonato, embarcação Voadeira Rio Negro II, métricas de saídas e valores a receber, ação de cadastrar saída e a lista de saídas programadas com ocupação e validação de voucher.

#### Scenario: Saídas programadas do barqueiro
- **WHEN** o painel do barqueiro é aberto com os dados de demonstração
- **THEN** o sistema mostra Manaus → Tumbira às 08:30 por R$ 120 com 6/10 vagas e Tumbira → Comunidade Catalão às 14:00 por R$ 90 com 3/8 vagas

#### Scenario: Métricas de operação do barqueiro
- **WHEN** o painel calcula as saídas de demonstração
- **THEN** o sistema mostra 2 saídas hoje e R$ 990 a receber

### Requirement: Painel do Guia
O sistema SHALL apresentar o Painel do Guia com Jairo da Silva, a identificação Guia Cadastur, a agenda ativa “Trilha das Samaúmas (09:00) - 8 Ecoturistas”, as ações de cadastrar vivência e liberar selo, e as trilhas publicadas com intensidade, duração, limite e GPS.

#### Scenario: Trilhas publicadas do guia
- **WHEN** o painel do guia é aberto com os dados de demonstração
- **THEN** o sistema mostra Trilha das Samaúmas como Moderada, 3h, 10 pessoas e GPS -3.0831°, -60.0512°, e Vivência Casa de Farinha como Leve, 1h30, 8 pessoas e GPS -3.0902°, -60.0418°

### Requirement: Painel da Artesã e estoque local
O sistema SHALL apresentar o Painel da Artesã com Dona Zete, Ateliê Ribeirinho, 14 peças em estoque, renda “100% no Território”, ação para cadastrar peça e a vitrine com os produtos, materiais, preços e controles de quantidade.

#### Scenario: Vitrine com inventário inicial
- **WHEN** o painel da artesã é aberto com os dados de demonstração
- **THEN** o sistema mostra Colar Jarina Natural com 5 peças a R$ 45 e Pulseira Fibra de Arumã com 9 peças a R$ 25

#### Scenario: Ajuste de estoque
- **WHEN** a artesã aciona mais ou menos em um item da vitrine
- **THEN** o sistema altera a quantidade exibida em uma unidade e não permite valor abaixo de zero

### Requirement: Painel da Cozinheira e porções reservadas
O sistema SHALL apresentar o Painel da Cozinheira com Dona Antônia, Cozinha Tradicional, o alerta da atracação da Voadeira Rio Negro às 12:00 com 6 almoços reservados, a ação de programar cardápio e os itens do cardápio com preço, horário, reservas, progresso e controle numérico.

#### Scenario: Cardápio inicial
- **WHEN** o painel da cozinheira é aberto com os dados de demonstração
- **THEN** o sistema mostra Peixe Moqueado com Farinha por R$ 45, das 11:30 às 13:30, com 14 de 20 pratos reservados, e Café com Tucumã e Bolo de Macaxeira por R$ 20, das 06:00 às 08:00, com 8 de 15 reservados

#### Scenario: Alteração de porções reservadas
- **WHEN** a cozinheira ajusta a reserva de um prato
- **THEN** o sistema atualiza o total, o percentual e a barra de progresso sem permitir total menor que zero ou maior que a capacidade do prato

### Requirement: Progresso e sinalização de capacidade
O sistema SHALL calcular o progresso de vagas e porções a partir dos totais atuais e sinalizar visualmente ocupação baixa, intermediária e alta, usando os limiares de 50% e 80% definidos pelo protótipo.

#### Scenario: Ocupação intermediária
- **WHEN** uma saída possui 6 de 10 vagas preenchidas
- **THEN** o sistema mostra 60% ocupado e uma barra de progresso de atenção intermediária

### Requirement: Ações fora do escopo operacional
O sistema SHALL manter as ações de cadastrar saída, cadastrar trilha/vivência, liberar selo, validar voucher, cadastrar artesanato e programar cardápio visíveis e acionáveis; quando o fluxo correspondente não estiver disponível nesta entrega, SHALL informar que a ação será disponibilizada em fluxo posterior.

#### Scenario: Ação sem fluxo implementado
- **WHEN** o prestador aciona uma ação operacional sem tela ou serviço correspondente nesta entrega
- **THEN** o sistema mostra um retorno textual acessível sem alterar os dados exibidos no painel

### Requirement: Responsividade e acessibilidade dos painéis
O sistema SHALL manter os quatro painéis utilizáveis entre 320 e 1024 pixels lógicos de largura, com conteúdo rolável, botões e controles com alvos de toque de pelo menos 44 pixels lógicos, texto com contraste suficiente e rótulos semânticos para imagens e controles icônicos.

#### Scenario: Painel em tela compacta
- **WHEN** qualquer painel de prestador é renderizado com 320 pixels lógicos de largura
- **THEN** o conteúdo permanece em uma coluna legível, sem rolagem horizontal da página e com as ações ainda alcançáveis
