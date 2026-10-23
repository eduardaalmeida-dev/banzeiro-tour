# Banzeiro Tour

Aplicativo Flutter com autenticação por token na API Laravel localizada em `api/`.

## Identidade visual

As cores, componentes e regras de interface para novas telas estão documentados em [docs/visual-identity.md](docs/visual-identity.md). Use também os tokens de `lib/core/theme/app_visual_identity.dart`.

## Desenvolvimento do login

### 1. Inicie a API Laravel

Para um banco local novo, execute as migrações e o seeder para disponibilizar a conta de teste:

```powershell
cd api
php artisan migrate --seed
php artisan serve --host=127.0.0.1 --port=8000
```

Com o seeder padrão, use `test@example.com` e a senha `password` para testar o login.

### 2. Execute no emulador Android

Em outro terminal, na raiz do projeto:

```powershell
flutter run
```

Sem configuração adicional, o aplicativo usa `http://10.0.2.2:8000/api`. Esse endereço é o alias do emulador Android para o `127.0.0.1` da máquina de desenvolvimento.

### 3. Execute em dispositivo físico ou com API publicada

Informe uma URL que o dispositivo consiga alcançar por meio de `API_BASE_URL`:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8000/api
```

Para teste em rede local, inicie o Laravel aceitando conexões externas:

```powershell
cd api
php artisan serve --host=0.0.0.0 --port=8000
```

Substitua `192.168.0.10` pelo IP local da máquina. Em ambientes publicados, use uma URL HTTPS da API.

## Verificação

```powershell
cd api
php artisan test

cd ..
flutter analyze
flutter test
```
