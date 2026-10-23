# Tasks

## 1. Dependências e base multiplataforma

- [x] 1.1 Adicionar `hive_ce`, `hive_ce_flutter` e `image_picker` ao `pubspec.yaml`, atualizar os arquivos de lock e verificar com `flutter pub get`.
- [ ] 1.2 Configurar as descrições de uso de câmera/biblioteca no iOS e os requisitos de seleção de arquivo nos alvos necessários, verificando que os projetos Android, iOS e Web ainda compilam.
- [x] 1.3 Criar a estrutura de módulos para domínio, armazenamento local, repositórios, estado e telas de cadastro; verificar que todos os imports do aplicativo continuam resolvidos com `flutter analyze`.

## 2. Modelos, armazenamento e migrações locais

- [x] 2.1 Implementar modelos imutáveis e mapeadores dos quatro catálogos com todos os campos definidos nos specs, conversões numéricas seguras e limites de capacidade; verificar com testes unitários de serialização e validação.
- [x] 2.2 Implementar a inicialização Hive CE, metadados de versão e a migração idempotente `v0 → v1` que cria as caixas de catálogos e imagens sem dados de demonstração; verificar com teste de primeira inicialização e teste de preservação de registro em versão compatível.
- [x] 2.3 Implementar repositórios de saídas, trilhas, peças e refeições com inserção, listagem e atualização limitada de estoque/reservas; verificar com testes de persistência, isolamento entre catálogos e clamp de zero à capacidade.
- [x] 2.4 Implementar o repositório de mídia de artesanato que persiste bytes por URI lógico e reconhece o placeholder offline; verificar com teste de resolução de imagem salva e de fallback sem foto.

## 3. Estado observável e inicialização do aplicativo

- [x] 3.1 Implementar o `ProviderCatalogController` e estados imutáveis de carregamento, vazio, pronto e falha, com notificações após operações persistidas; verificar com testes usando repositórios falsos.
- [x] 3.2 Adicionar o escopo `InheritedNotifier`/injeção de dependências para o controlador e inicializar o armazenamento antes de `runApp`; verificar com teste de widget que um painel recebe estado vazio sem abrir uma base real.
- [x] 3.3 Adicionar tratamento recuperável de erro de inicialização/gravação, bloqueio contra submit duplicado e doubles de teste para os repositórios; verificar com testes de erro que preservam o formulário e não navegam indevidamente.

## 4. Formulários de cadastro de prestadores

- [x] 4.1 Criar componentes reutilizáveis de campo com ícone, seleção em pílula, card tracejado, contador e rodapé seguro de confirmação, preservando os tamanhos e cores dos protótipos; verificar com testes de widget nos estados ativo/inativo e em largura de telefone.
- [x] 4.2 Implementar a tela de nova saída de barco com valores iniciais, ajuste de horário de 30 minutos, contador de 1–12 e validações de trecho/preço; verificar que um submit válido cria uma saída com zero reservas e que entradas inválidas não gravam.
- [x] 4.3 Implementar a tela de nova trilha com níveis, contador de 1–30 e captura GPS offline simulada; verificar criação com coordenada capturada e com o marcador `Não capturado`.
- [x] 4.4 Implementar a tela de nova peça de artesanato com seleção/captura de imagem, fallback local, materiais e contador de 1–99; verificar preview/fallback e persistência de uma peça válida.
- [x] 4.5 Implementar a tela de nova refeição com tipos, horários de início/fim, contador de 1–100 e validação de janela; verificar que fim anterior ao início impede a gravação e que uma refeição válida inicia com zero reservas.
- [x] 4.6 Substituir as mensagens de recurso indisponível dos quatro botões principais por navegação para os formulários e retorno somente após sucesso; verificar em testes que cancelar não cria registro e confirmar atualiza o painel de origem.

## 5. Painéis conectados ao catálogo local

- [x] 5.1 Refatorar os painéis de barqueiro e guia para lerem o controlador em vez de `DemoDashboardData`, incluindo carregamento, vazio, erro e métricas de saídas/valor a receber; verificar com widgets que dados persistidos aparecem e dados de demonstração não aparecem.
- [x] 5.2 Refatorar o painel da artesã para carregar fotos/placeholder e estoque do repositório, persistindo os ajustes de estoque; verificar que o contador e o total sobrevivem à recriação do controlador.
- [x] 5.3 Refatorar o painel da cozinheira para carregar refeições e persistir o ajuste de reservas dentro dos limites; verificar a barra de progresso, os limites e a sobrevivência à recriação do controlador.
- [x] 5.4 Remover as listas estáticas de prestador e as cópias locais em memória, preservando somente os dados de experiências turísticas fora do escopo; verificar com busca no código que os painéis não importam mais os dados de demonstração de prestador.

## 6. Validação integrada

- [x] 6.1 Atualizar os testes legados que dependem de dados pré-carregados para usar fakes e cobrir primeiro acesso vazio, persistência após reinício, falha de escrita e isolamento dos quatro catálogos; verificar com `flutter test`.
- [x] 6.2 Executar `dart format .`, `flutter analyze` e `flutter test`; corrigir todos os erros, avisos relevantes e falhas antes da revisão.
- [ ] 6.3 Validar manualmente em largura de telefone e em Flutter Web que cada formulário respeita o protótipo, funciona sem rede após o primeiro carregamento e atualiza seu painel ao salvar.

## Workflow follow-up

- Após a revisão dos artefatos e da implementação, arquivar a mudança OpenSpec conforme o fluxo do projeto.
