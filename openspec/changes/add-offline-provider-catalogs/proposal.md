# Proposal

## Why

Os painéis de operação dos prestadores exibem dados de demonstração e os seus fluxos de cadastro ainda não existem, impedindo que barqueiros, guias, artesãs e cozinheiras registrem e consultem seu próprio catálogo sem conexão. É necessário tornar esses fluxos realmente utilizáveis offline e manter os painéis atualizados a partir dos registros persistidos.

## What Changes

- Adicionar uma base local versionada, inicializada antes da interface e compatível com os alvos mobile e web/PWA do Flutter, para persistir saídas de barco, trilhas, peças de artesanato e refeições.
- Adicionar modelos, repositórios e estado observável por perfil para criar, consultar e atualizar os quatro catálogos locais sem depender de rede.
- Criar formulários de cadastro para cada perfil com os controles descritos no briefing (seletores, steppers, preço, horários, GPS simulado e imagem da peça), validação e retorno ao painel após a gravação offline.
- Substituir os dados estáticos de `DemoDashboardData` e as mutações apenas em memória dos painéis por consultas e atualizações persistidas; os painéis passam a apresentar estado vazio quando o catálogo local ainda não possuir registros.
- Preservar a identidade visual e os componentes de painel existentes; os novos formulários seguirão as indicações visuais fornecidas no briefing. **BREAKING**: instalações limpas deixam de exibir o catálogo de demonstração pré-carregado.

## Capabilities

### New Capabilities

- `offline-provider-catalogs`: mantém os catálogos operacionais dos quatro perfis em armazenamento local versionado e os disponibiliza de forma reativa aos painéis.
- `provider-catalog-registration`: permite que cada perfil cadastre seu respectivo item de catálogo offline por meio de um formulário validado.

### Modified Capabilities

Nenhuma.

## Impact

- Afeta `pubspec.yaml`, inicialização em `lib/main.dart`, os modelos/dados do dashboard, os quatro painéis de prestador e a navegação a partir de seus botões principais.
- Introduz dependências de armazenamento local multiplataforma, seleção/captura de imagem e gerenciamento de estado baseado em `ChangeNotifier` (ou equivalente sem dependência externa adicional).
- Exige testes de migração/persistência, repositórios, formulários, estados vazios e atualização reativa dos painéis; os testes atuais que afirmam dados de demonstração serão substituídos ou adaptados.
