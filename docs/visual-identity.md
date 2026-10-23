# Identidade visual — Banzeiro Tour

Use este guia em todas as novas telas Flutter para manter a linguagem visual do aplicativo consistente. Os tokens reutilizáveis estão em `lib/core/theme/app_visual_identity.dart`.

## Direção visual

- Interface leve, acolhedora e inspirada na natureza amazônica.
- Fundo claro, conteúdo com boa margem lateral e destaque para o verde institucional.
- Componentes arredondados, leitura simples e hierarquia forte nos títulos.
- Evitar excesso de bordas, sombras pesadas, cores vibrantes fora da paleta e texto todo em maiúsculas, exceto em identificadores pequenos de marca.

## Cores

| Uso | Token | Cor |
| --- | --- | --- |
| Ação principal e item selecionado | `AppVisualIdentity.primaryGreen` | `#0B7A43` |
| Títulos e textos de alta ênfase | `AppVisualIdentity.darkGreen` | `#103B27` |
| Destaques suaves e blocos informativos | `AppVisualIdentity.softGreen` | `#E8F4EC` |
| Fundo das páginas | `AppVisualIdentity.pageBackground` | `#F5F7F6` |
| Fundo de campos | `AppVisualIdentity.fieldBackground` | `#F1F4F2` |
| Texto secundário | `AppVisualIdentity.mutedText` | `#6B8275` |
| Borda discreta | `AppVisualIdentity.subtleBorder` | `#DFE7E2` |

## Tipografia

- Usar a fonte padrão do Material enquanto não houver uma família tipográfica própria no projeto.
- Título principal: 30–32 px, peso `w800`, verde escuro e entrelinha compacta.
- Título de seção: 17–20 px, peso `w800`, verde escuro.
- Corpo: 14–15 px; texto secundário em `mutedText`.
- Rótulos de campos e chips: 13–14 px, peso `w600` ou `w700`.

## Componentes

- Margem horizontal padrão: 20 px.
- Botão primário: verde institucional, texto branco, altura mínima de 56–58 px e raio de 18 px.
- Campos: fundo suave, ícone verde à esquerda, raio de 18 px e borda verde de 1,5 px em foco.
- Cartões: fundo branco, raio de 24 px e sombra verde/preta muito sutil.
- Chips: formato cápsula (`StadiumBorder`); selecionado em verde com texto branco e não selecionado branco com borda discreta.
- Botão de voltar: superfície branca, quadrado arredondado de aproximadamente 48 px e ícone verde.
- Imagens de experiências: cantos arredondados e conteúdo preservado com `BoxFit.cover`.

## Responsividade e acessibilidade

- Formulários e listas longas devem usar rolagem vertical.
- Não reduzir a área de toque de botões ou chips abaixo de 44 px.
- Manter contraste alto entre texto e fundo; mensagens de erro não podem depender apenas de cor.
- Incluir `semanticLabel` em logos e imagens que transmitam informação.
