# Spec Delta

## Purpose

Mantém os catálogos operacionais dos prestadores disponíveis offline e garante que cada painel apresente somente dados persistidos e atualizados do seu próprio perfil.

## ADDED Requirements

### Requirement: Catálogos de prestadores persistem localmente
O sistema SHALL manter, sem depender de conexão, catálogos separados de saídas de barco, trilhas, peças de artesanato e refeições. Os registros criados SHALL continuar disponíveis após encerrar e reabrir o aplicativo, inclusive em execução web/PWA.

#### Scenario: Aplicativo inicia sem registros locais
- **WHEN** o aplicativo é aberto em uma instalação sem registros salvos
- **THEN** cada painel de prestador exibe um estado vazio orientando o cadastro e não apresenta dados de demonstração

#### Scenario: Catálogo é reaberto offline
- **WHEN** o usuário reinicia o aplicativo sem conexão após salvar itens em um catálogo
- **THEN** os itens persistidos daquele catálogo são carregados e exibidos normalmente

### Requirement: Registros contêm os dados operacionais requeridos
O sistema SHALL conservar um identificador único e todos os atributos operacionais de cada tipo de catálogo: barco, origem, destino, partida, lotação, reservas e preço; nome, nível, duração, GPS e limite de trilha; foto, nome, matéria-prima, estoque e preço de peça; tipo, prato, janela, limite, reservas e preço de refeição.

#### Scenario: Valores monetários e capacidades são recuperados
- **WHEN** um item de qualquer catálogo é salvo e posteriormente consultado
- **THEN** seus valores de preço, capacidade/estoque e demais campos são iguais aos confirmados no cadastro

### Requirement: Evolução da estrutura local preserva os catálogos
O sistema SHALL controlar a versão da estrutura de dados local e aplicar atualizações compatíveis antes de disponibilizar os catálogos à interface. Uma atualização de versão SHALL preservar os registros existentes sempre que os seus campos continuarem suportados.

#### Scenario: Aplicativo encontra uma versão anterior da base
- **WHEN** o aplicativo inicializa com dados gravados em uma versão anterior compatível
- **THEN** a atualização necessária é concluída antes da leitura e os registros existentes continuam acessíveis

### Requirement: Painéis refletem seus catálogos persistidos
O sistema SHALL carregar cada painel a partir do respectivo catálogo local e atualizar sua interface quando esse catálogo mudar. O painel do barqueiro SHALL calcular quantidade de saídas e valor a receber a partir das vagas reservadas e preço; os demais SHALL refletir trilhas, estoque e reservas persistidos.

#### Scenario: Novo registro aparece no painel de origem
- **WHEN** o usuário conclui o cadastro de um item e retorna ao painel correspondente
- **THEN** o novo item é exibido sem reiniciar o aplicativo e os indicadores derivados são recalculados

#### Scenario: Quantidade operacional é ajustada no painel
- **WHEN** o usuário altera o estoque de uma peça ou as reservas de uma refeição pelos controles disponíveis
- **THEN** o novo valor respeita o intervalo de zero à capacidade aplicável e permanece após reabrir o aplicativo

### Requirement: Catálogos não compartilham registros entre perfis
O sistema SHALL apresentar no painel de cada perfil somente os registros do seu tipo de catálogo e SHALL manter os dados de um catálogo inalterados quando outro catálogo for consultado ou atualizado.

#### Scenario: Catálogos coexistem na mesma instalação
- **WHEN** existem uma saída, uma trilha, uma peça e uma refeição salvas localmente
- **THEN** cada painel mostra apenas o item compatível com seu perfil
