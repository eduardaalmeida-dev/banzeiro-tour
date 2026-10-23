# Tasks

## 1. Fundação visual, dados e roteamento

- [x] 1.1 Estender `AppVisualIdentity` com os tokens de painel e capacidade, criar os modelos tipados e dados demonstrativos equivalentes a `prototype/bolt-react/src/data.ts`, e verificar com testes unitários os totais e percentuais calculados (incluindo R$ 990 e 60%).
- [x] 1.2 Criar widgets reutilizáveis de estrutura (app bar, botão de ação, cabeçalho de prestador, métrica, progresso, contador e navegação inferior turística) e verificar com testes de widget que os controles têm rótulos semânticos e alvos de toque mínimos.
- [x] 1.3 Criar o resolvedor de destino por `UserProfileType` e conectá-lo ao cadastro e ao login quando `profile_type` for válido, preservando a confirmação de login legada quando estiver ausente; verificar os cinco destinos e o fallback nos testes de `LoginView` e `RegistrationView`.

## 2. Experiência do turista

- [x] 2.1 Implementar `tourist_explore_page.dart` com cabeçalho de localização/status, campo de busca, chips horizontais e filtragem sem distinção de maiúsculas por título ou anfitrião; verificar filtros, busca e estado sem resultados em teste de widget.
- [x] 2.2 Implementar cards de experiências com mídia de altura fixa, badges sobrepostos, preço, avaliações e fallback de imagem, além da barra inferior fixa com os quatro destinos e feedback para áreas ainda indisponíveis; verificar todos os textos obrigatórios e o fallback em teste de widget.
- [x] 2.3 Renderizar a tela Explorar em 320 px e em largura ampla nos testes, verificando ausência de overflow horizontal, acesso aos filtros por rolagem e espaço final para a navegação fixa.

## 3. Painéis operacionais de prestadores

- [x] 3.1 Implementar `boatman_panel_page.dart` e `guide_panel_page.dart` com os cabeçalhos, métricas/agenda, ações e cards de saída/trilha correspondentes ao protótipo; verificar conteúdo, cores de ocupação e dados de demonstração em testes de widget.
- [x] 3.2 Implementar `artisan_panel_page.dart` com a vitrine em duas colunas responsivas e ajuste local de estoque limitado a zero; verificar estoque inicial de 14, atualização de contadores e layout compacto em teste de widget.
- [x] 3.3 Implementar `cook_panel_page.dart` com alerta de atracação, cards de cardápio, progresso e contador de porções limitado à capacidade; verificar os valores iniciais, os dois limites e a atualização percentual em teste de widget.
- [x] 3.4 Conectar as ações ainda sem fluxo (cadastros, selo e QR Code) a retorno textual acessível e verificar que seu acionamento não modifica os dados demonstrativos em testes de widget.

## 4. Verificação integrada

- [x] 4.1 Executar `flutter analyze` e `flutter test`, corrigindo falhas de análise, testes existentes e novos testes de navegação, responsividade e interações locais.
- [x] 4.2 Executar `flutter build web` e revisar os cinco estados iniciais a 390×844, 320 px e largura ampla contra os protótipos, registrando quaisquer desvios visuais residuais antes da revisão.

## Workflow follow-up

- Após a implementação e a revisão visual, aplicar e então arquivar esta mudança OpenSpec conforme o fluxo do projeto.
