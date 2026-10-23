# Design

## Context

The current Laravel 13 bootstrap loads only web routes, while the login definition lives in an API route file that has no PHP opening tag. Flutter posts JSON to a hard-coded emulator URL and collapses every unsuccessful HTTP response and transport exception into `null`. Android declares internet access only in the debug and profile manifests. See `proposal.md` and the `mobile-login-authentication` spec for the required behavior.

## Goals / Non-Goals

**Goals:**

- Make the existing Sanctum token login route reachable at `/api/login`.
- Preserve the Android emulator development path while allowing another API origin to be supplied at build time.
- Give the login view a safe, actionable outcome for each category of failure.
- Cover the API contract and client result mapping with automated tests.

**Non-Goals:**

- Creating registration, password-reset, logout, token persistence, or authenticated business routes.
- Starting, monitoring, or deploying the Laravel server from the mobile app.
- Replacing the existing local-development HTTP transport with production TLS infrastructure.

## Decisions

### Register the existing API route file in the Laravel bootstrap

`bootstrap/app.php` will pass `api: __DIR__.'/../routes/api.php'` to Laravel's routing configuration, which applies the framework's `api` prefix. `routes/api.php` will receive its PHP opening tag and retain the current login contract and Sanctum token creation.

This is the smallest repair that makes the intended `/api/login` endpoint executable. Moving the closure to a controller is deferred because it does not change the required behavior and would expand the repair.

### Make the API origin a compile-time Flutter setting

The service will read `API_BASE_URL` through `String.fromEnvironment`, with `http://10.0.2.2:8000/api` as its default. It will normalize a trailing slash before building the login URI. Builds for physical devices or hosted environments can supply `--dart-define=API_BASE_URL=<url>`.

A runtime configuration file or dotenv package is not needed for this small mobile client and would add runtime deployment concerns. The default remains scoped to Android emulator development; a production endpoint must use an explicit build value.

### Use typed login outcomes instead of a nullable response

The API service will expose a result type that separates authenticated responses, rejected credentials (401), API/validation failures (other non-2xx responses), and transport/timeout failures. The login view will map those outcomes to distinct Portuguese messages while preserving the existing success greeting.

The service will accept an HTTP client dependency so unit tests can provide deterministic responses. Diagnostic logging of raw response bodies will be removed; neither passwords, tokens, nor complete server payloads will be written to logs or shown in the UI. Returning `null` was rejected because it discards the information needed for accurate feedback.

### Declare Android internet access in the main manifest

`android.permission.INTERNET` will be placed in the main manifest so merged release manifests also contain it. The existing development cleartext setting will remain for the local emulator endpoint. Hosted production builds are expected to pass an HTTPS API URL.

### Test at the API boundary and client mapping boundary

Laravel feature tests will use the existing in-memory SQLite test configuration and a user factory to verify route availability, valid credentials, invalid credentials, and invalid payload validation. Flutter unit tests will use the `http` package's test client to verify URI construction and HTTP/transport outcome mapping; a focused widget test will verify the login view displays the corresponding user-facing message.

## Risks / Trade-offs

- [The configured server is not running or cannot be reached from the selected device] -> The client reports a connection failure, and the development instructions will require starting Laravel before testing.
- [A physical device cannot resolve `10.0.2.2`] -> Builds for such devices must provide a reachable LAN or hosted URL through `API_BASE_URL`.
- [HTTP cleartext is unsafe for production credentials] -> Keep it only for local development and configure an HTTPS URL for distributed builds.
- [Each successful login creates a new Sanctum token] -> Preserve current behavior in this repair; token reuse or revocation is a separate authentication-lifecycle change.

## Migration Plan

1. Apply the Laravel route/bootstrap and Android manifest changes.
2. Run the Laravel feature suite and Flutter tests.
3. Start the Laravel server, then run the Android emulator with the default API origin; use `API_BASE_URL` explicitly for a physical device or hosted server.
4. Roll back by reverting the change if deployment problems occur; no schema or persisted-data migration is involved.
