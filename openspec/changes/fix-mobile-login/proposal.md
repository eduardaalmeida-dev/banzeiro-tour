# Proposal

## Why

The Flutter application cannot complete login because its expected `POST /api/login` endpoint is not registered by the Laravel bootstrap, and the API route file is not valid PHP. The client also reports every non-success response as an invalid credential error, obscuring routing and network failures.

## What Changes

- Register the Laravel API route file and make the existing token-based login endpoint available at `POST /api/login`.
- Correct the API route file so Laravel executes its login definition.
- Allow Android builds, including release builds, to make network requests to the configured API.
- Configure the Flutter API origin per build target while retaining an Android-emulator-friendly local default.
- Return typed login outcomes in Flutter so the interface distinguishes invalid credentials, request validation/API failures, and unavailable-network/server failures without exposing response bodies or passwords.
- Add focused backend and Flutter coverage for the successful and failure login paths.

## Capabilities

### New Capabilities

- `mobile-login-authentication`: Authenticate a mobile user against the Laravel API and present an accurate outcome for successful, rejected, malformed, and unreachable login requests.

### Modified Capabilities

- None.

## Impact

- Laravel routing and login endpoint files under `api/bootstrap` and `api/routes`.
- Flutter API client and login view under `lib/core/services` and `lib/presentation/auth`.
- Android manifest network permission and build-time API endpoint configuration.
- New or updated Laravel feature tests and Flutter unit/widget tests; no new runtime dependencies are expected.
