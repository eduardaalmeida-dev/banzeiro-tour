# Proposal

## Why

O aplicativo atualmente permite apenas autenticar contas já existentes, impedindo que turistas e prestadores comunitários ingressem pelo próprio fluxo mobile. É necessário cadastrar os cinco perfis do ecossistema Banzeiro Tour e deixar prestadores pendentes de homologação desde a criação da conta, atendendo ao RF01.

## What Changes

- Adicionar, na tela de login Flutter, uma entrada **Cadastre-se** para um fluxo de cadastro guiado por perfil.
- Permitir selecionar Turista, Barqueiro, Guia, Artesã ou Cozinheira e exibir os campos obrigatórios correspondentes antes do envio.
- Expor `POST /api/register` no Laravel para validar o cadastro, criar a conta e o perfil especializado, e emitir um token Sanctum.
- Persistir a identidade comum em usuário e os dados específicos em perfis de turista ou prestador; novos prestadores começam com `verificado = false`.
- Retornar o perfil e o estado de verificação junto da autenticação de cadastro para que o app abra a home adequada, mostrando a situação pendente quando aplicável.
- Cobrir o novo contrato de API e as validações/interações do formulário com testes automatizados.

## Capabilities

### New Capabilities

- `identity/user-registration`: cadastro autenticado de turistas e prestadores locais, incluindo seleção de perfil, validação, persistência de dados especializados e status inicial de homologação.

### Modified Capabilities

- Nenhuma.

## Impact

- Flutter: `LoginView`, nova tela/estado de cadastro, `ApiService`, modelos de resposta, navegação inicial e testes de widget/serviço.
- Laravel: rota e controlador/serviço de registro, regras de validação, modelos e migrações para usuários e perfis, testes de feature e tokens Sanctum.
- Banco de dados: o modelo passará a armazenar papel do usuário e dados de perfil em PostgreSQL. A configuração local atual usa SQLite como padrão, portanto o ambiente que executar a entrega deverá fornecer variáveis de conexão PostgreSQL compatíveis.
- Não inclui cadastro offline, sincronização local, nem o processo administrativo que efetivamente homologa um prestador.
