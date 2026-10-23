# Proposal

## Why

O app Flutter já possui autenticação e a seleção dos cinco perfis, mas a área autenticada ainda é uma home genérica. Os protótipos React presentes no repositório definem a experiência visual e operacional esperada para turista, barqueiro, guia, artesã e cozinheira; é necessário transportá-los com fidelidade para telas Flutter responsivas.

## What Changes

- Criar a tela turística **Explorar**, com cabeçalho de localização/status, busca, filtros por categoria, cards de experiências e navegação inferior fixa.
- Criar painéis independentes para Barqueiro, Guia, Artesã e Cozinheira, com cabeçalhos de perfil por papel, métricas/alertas, ações de destaque e listas operacionais correspondentes.
- Extrair modelos de demonstração, tokens visuais e widgets compartilhados para manter os cinco layouts consistentes com o protótipo e adequados a telas compactas e largas.
- Adicionar a seleção da tela inicial autenticada conforme `UserProfileType`, substituindo a atual home genérica após cadastro e login quando os dados de perfil estiverem disponíveis.
- Implementar as interações que fazem parte dessas telas: busca e filtros do catálogo, variação local de estoque e de porções dentro de limites, e feedback para ações cujo fluxo de cadastro/validação ainda não integra esta mudança.
- Cobrir layout, conteúdo, roteamento por perfil e interações locais com testes de widget.

## Capabilities

### New Capabilities

- `tourism/experience-discovery`: catálogo turístico pesquisável e filtrável, com cards de experiências e navegação inferior do turista.
- `provider/community-operation-panels`: painéis operacionais específicos para barqueiro, guia, artesã e cozinheira, incluindo indicadores, listagens e controles locais.

### Modified Capabilities

- Nenhuma. Não há especificações principais existentes para o fluxo de autenticação ou homes de perfil; o roteamento será coberto pelas novas capacidades.

## Impact

- Flutter: novas views em `lib/presentation`, widgets/modelos de apoio, tema e ponto de roteamento pós-autenticação em `LoginView` e `RegistrationView`.
- Testes: novos testes de widget para cada tela, navegação por perfil, busca/filtros e controles numéricos.
- Assets: as imagens de experiência e de artesanato devem ter alternativas locais ou tratamento de falha de carregamento para manter os cards legíveis no app/PWA.
- Não inclui backend, persistência remota, cadastro de novas saídas/trilhas/peças/refeições, leitura real de QR Code ou a implementação das telas de Passaporte, Voucher e Perfil.
