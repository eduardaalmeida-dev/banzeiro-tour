# Design

## Context

Veja `proposal.md` para a motivação. O projeto é um app Flutter Material 3 pequeno, com identidade visual em `AppVisualIdentity`, autenticação em `ApiService` e uma `ProfileHomeView` genérica aberta após o cadastro. Os protótipos de referência estão em `prototype/bolt-react/src`: `CatalogScreen.tsx`, os quatro painéis de prestador, `BottomNav.tsx`, `AppBar.tsx`, `Button.tsx` e `data.ts`.

O repositório ainda não possui uma fonte de dados operacional nem imagens de experiências copiadas para `assets/`. Portanto, esta entrega precisa representar fielmente os dados de demonstração e permanecer resiliente se as imagens de referência não puderem ser carregadas.

## Goals / Non-Goals

**Goals:**

- Transportar os cinco layouts de referência para Flutter preservando hierarquia, conteúdo, cores por papel, raios, espaçamentos, áreas de toque e comportamento em larguras compactas e amplas.
- Separar cada página pedida em arquivo próprio: `tourist_explore_page.dart`, `boatman_panel_page.dart`, `guide_panel_page.dart`, `artisan_panel_page.dart` e `cook_panel_page.dart`.
- Reutilizar componentes de estrutura e dados tipados sem criar dependências de gerenciamento de estado para interações exclusivamente locais.
- Direcionar uma sessão que tenha `profile_type` reconhecido à área correspondente, sem quebrar as respostas de login legadas que não trazem esse campo.

**Non-Goals:**

- Criar APIs, persistência, câmera/QR Code, formulários de cadastro de saídas, trilhas, artesanato ou cardápio.
- Implementar as telas de detalhe, Passaporte, Meu Voucher ou Perfil que aparecem apenas como destinos da navegação do protótipo.
- Tornar estoque ou reservas alterações persistentes entre reinicializações; eles permanecem estados demonstrativos da tela.
- Incluir uma família tipográfica ou uma nova dependência somente para reproduzir o protótipo web.

## Decisions

### 1. Organizar páginas e componentes por responsabilidade visual

As páginas serão criadas sob `lib/presentation/experience/views/tourist_explore_page.dart` e `lib/presentation/provider/views/` para os quatro painéis. Widgets repetidos ficarão em um diretório irmão de `widgets/`: barra superior, navegação inferior turística, botão de ação, cabeçalho de prestador, cartão de métrica, barra de capacidade e contador numérico.

Os cards e cabeçalhos específicos permanecem perto de sua página. Isso evita um único widget genérico cheio de condicionais para quatro painéis visualmente distintos, mas mantém medidas repetidas e semântica coerentes.

Alternativa considerada: deixar toda a composição em uma `ProfileHomeView`. Foi descartada porque dificultaria testar cada estado e contrariaria os arquivos modulares solicitados.

### 2. Usar dados demonstrativos tipados e estado local limitado

Os conteúdos de `data.ts` serão convertidos para modelos Dart imutáveis e uma fonte de dados demonstrativos interna ao Flutter. As páginas de Artesã e Cozinheira serão `StatefulWidget`s para alterar somente os contadores de estoque e de reservas; Barqueiro calcula totais/ocupação a partir das saídas e Guia apresenta a agenda e trilhas fixas.

Os cálculos são: valor a receber = soma de `reservas × preço`; percentual = valor atual ÷ capacidade; a barra usa verde abaixo de 50%, amarelo de 50% a menos de 80% e terracota/vermelho a partir de 80%. Contadores nunca cruzam seus limites.

Alternativa considerada: introduzir Provider, Riverpod ou persistência local. Foi descartada pois não há fonte remota nem requisito de sobrevivência de estado, e adicionaria complexidade/desvio visual sem benefício observável nesta mudança.

### 3. Tratar fidelidade visual como implementação de tokens e componentes

`AppVisualIdentity` receberá somente os tokens complementares necessários: azul-petróleo do barqueiro, verde-floresta do guia, dourado da artesã, terracota da cozinheira e os tons de capacidade. A interface usará `Scaffold`, `SafeArea`, raio de 16–24, margens laterais de 16–20, cartões claros, elevação sutil e alturas de referência do protótipo (imagens de experiência com 176 px, ações principais com pelo menos 52 px e controles com pelo menos 44 px).

Em telas largas, o conteúdo ficará centralizado com largura máxima de leitura, preservando uma coluna no lugar de uma grade de painel; a vitrine da artesã mantém duas colunas quando houver largura suficiente e reduz de forma segura quando não houver. Listas terão espaço inferior reservado para a barra de navegação fixa.

Alternativa considerada: incorporar o protótipo React/WebView. Foi descartada porque o aplicativo é Flutter e essa abordagem não gera componentes nativos responsivos nem testáveis no ecossistema existente.

### 4. Imagens remotas com fallback visual testável

As URLs Pexels já presentes no protótipo serão usadas como conteúdo de demonstração via `Image.network`, com `semanticLabel`, `BoxFit.cover`, altura fixa e `errorBuilder` que mantém o espaço, a sobreposição de avaliação/localidade e um preenchimento temático. Testes de widget não dependerão de rede; verificarão textos, estrutura e o fallback quando aplicável.

Alternativa considerada: baixar e versionar as imagens agora. Foi descartada no planejamento porque o repositório não contém esses assets e esta mudança não autoriza seleção/licenciamento de novas imagens. Um pacote de assets pode substituir as URLs futuramente sem alterar o contrato visual.

### 5. Roteamento pós-autenticação compatível com o contrato existente

Um resolvedor de destino receberá `UserProfileType` e retornará a página turística ou o painel adequado. `RegistrationView` já recebe um `RegisteredUser` e passará a usá-lo. `LoginView` continuará aceitando a resposta atual em mapa, mas reconhecerá `profile_type` quando ele for enviado; se estiver ausente ou inválido, exibirá a confirmação de login atual em vez de falhar ou encerrar a sessão.

A navegação inferior turística terá os quatro destinos obrigatórios. Apenas Explorar é implementado aqui; os demais itens fornecem retorno acessível de que a área ainda não está disponível, em vez de apontar para rotas inexistentes. As ações dos quatro painéis fazem o mesmo até que as mudanças futuras forneçam seus fluxos.

Alternativa considerada: tornar `profile_type` obrigatório na resposta de login. Foi descartada por ser uma quebra de compatibilidade para o servidor e para os testes existentes.

### 6. Verificar estrutura, comportamento e aparência responsiva

Serão criados testes de widget para os cinco arquivos de página, o roteamento de cada perfil, filtros/busca, métricas calculadas e limites dos contadores. Os testes também renderizarão a 320 px e a uma largura ampla para detectar overflow. Quando o ambiente de CI suportar golden tests estáveis, serão adicionadas referências de 390×844 para os estados iniciais; fontes e imagens externas serão substituídas por doubles determinísticos nesses testes.

Alternativa considerada: validar somente de modo manual em emulador. Foi descartada pois regressões de conteúdo, medição e overflow seriam fáceis de reintroduzir.

## Risks / Trade-offs

- [As imagens Pexels podem falhar sem rede ou mudar] → usar fallback com o mesmo recorte/altura e não depender delas para testes automatizados.
- [O backend de login atual pode não retornar `profile_type`] → usar roteamento por perfil apenas quando o campo for válido e preservar a confirmação legada nos demais casos.
- [“Pixel-perfect” pode variar com fonte e plataforma] → padronizar tamanhos, espaçamentos, raios e cores contra o protótipo, e adotar golden tests determinísticos como referência de regressão.
- [Ações visíveis sem fluxos de negócio poderiam sugerir funcionalidade inexistente] → fornecer feedback explícito e acessível de indisponibilidade até que cada fluxo seja entregue.
- [As mudanças locais de estoque e porções não persistem] → limitar a UI a dados demonstrativos e documentar que a futura integração substituirá a fonte local.

## Migration Plan

1. Adicionar modelos, dados de demonstração, tokens e widgets compartilhados sem alterar a rota inicial.
2. Implementar as cinco páginas e seus testes isolados.
3. Conectar o resolvedor de destino ao resultado de cadastro e ao login compatível.
4. Executar testes Flutter e validar em web/mobile nas larguras definidas.
5. Para reversão, restaurar a navegação para `ProfileHomeView`; os novos widgets e tokens não exigem migração de dados ou servidor.
