# Design

## Context

See `proposal.md` for the motivation and the two delta specs for the behavior contract. The Flutter application currently has provider panels that import `DemoDashboardData`; the craft and meal panels mutate private in-memory lists, and the primary buttons only show an unavailable-feature message. There is no local database, dependency-injection root, or state-management dependency. The repository also contains the source prototypes in `prototype/bolt-react`, which define the intended defaults, bounds, labels, fixed footer actions, and visual states for the four forms.

## Goals / Non-Goals

**Goals:**

- Persist and query all four provider catalog types on Android, iOS, Web/PWA, Windows, macOS, and Linux without a network dependency.
- Deliver a small, testable boundary between persistence, state, forms, and panels using Flutter-native observable state.
- Translate the existing React prototypes into the project’s Flutter visual identity, including their defaults and interactive bounds.
- Store an artisan image offline when supplied and render an offline-safe fallback when it is not.

**Non-Goals:**

- Synchronization, remote APIs, authentication scoping, multi-device conflict resolution, editing/deleting catalog records, and booking/voucher workflows.
- Real GPS, map, geocoding, or routing integrations; the trail action remains the specified offline simulation.
- A desktop camera implementation. Desktop uses image selection when camera capture is not supplied by the platform.

## Decisions

### Use Hive CE as the versioned local store

Add `hive_ce` and `hive_ce_flutter` and initialize storage before `runApp`. Hive CE is pure Dart and supports the project’s mobile, desktop, browser, and WASM/PWA targets, unlike `sqflite`, whose direct implementation is not a uniform web solution. Use a small set of named boxes:

| Box | Key | Value |
| --- | --- | --- |
| `schema_meta` | `schema_version` | current integer version |
| `boat_trips` | trip ID | serializable map with `boat_name`, `origin`, `destination`, `departure_time`, `max_capacity`, `current_booked`, `price_per_seat` |
| `trails` | trail ID | serializable map with `name`, `level`, `duration`, `gps_coordinates`, `max_people` |
| `crafts` | craft ID | serializable map with `photo_path`, `name`, `raw_material`, `quantity`, `price` |
| `meals` | meal ID | serializable map with `meal_type`, `dish_name`, `time_window`, `max_portions`, `reserved_portions`, `price` |
| `craft_images` | craft image ID | selected image bytes when an image was supplied |

The repositories own conversion between maps and immutable Dart domain models, including numeric normalization and safe capacity clamping. Keeping maps at the Hive boundary preserves the required field names and makes sequential migrations explicit without generated adapters. A typed-adapter/code-generation approach was considered, but is unnecessary for these simple records and would add build tooling to a project that does not use it today.

### Run sequential, idempotent schema migrations

`LocalDatabase.initialize()` opens the metadata box, reads `schema_version`, and runs each migration in order before opening repositories to the UI. The initial `v0 → v1` migration creates all catalog and image boxes without seeding data. Each later migration receives one version only, transforms compatible records defensively, and advances the version only after it succeeds. This establishes the requested migration mechanism while keeping a first install empty rather than moving demonstration values into production data.

### Isolate storage behind repositories and a Flutter-native controller

Create `lib/data/local/` for database bootstrap/migrations, `lib/data/repositories/` for one repository per catalog plus image storage, and `lib/domain/` for models and validation-ready value types. A `ProviderCatalogController extends ChangeNotifier` composes these repositories, exposes immutable per-catalog UI state (`loading`, `ready`, `empty`, `failure`), and serializes create/update operations. An `InheritedNotifier` scope created at the app root gives panels and forms access to the controller; `ListenableBuilder` rebuilds only the affected panel. This is the project’s equivalent to Provider/Bloc without adding a separate state package.

Panels will accept an optional injected controller/repository for widget tests. Production construction uses the app scope, while tests use deterministic fakes instead of opening the browser/device database.

### Treat the prototype as the form interaction reference

Create four routeable `StatefulWidget` form pages in a dedicated provider registration feature. Reuse the existing `ProviderPageScaffold`, buttons, `QuantityStepper`, colors, and typography; add shared field, selection-chip, and fixed-bottom-submit components only where the forms repeat behavior. Each page uses `Form` validation and keeps input in memory until the repository write succeeds.

The prototype-derived form state is:

| Form | Defaults and limits | Interaction |
| --- | --- | --- |
| Boat trip | boat `Voadeira Rio Negro II`, departure `08:30`, capacity 8 (1–12) | ±30-minute departure buttons; origin/destination icons; price input |
| Trail | level `Leve`, people 8 (1–30) | three level pills; dashed GPS card with short offline capture simulation; no capture persists `Não capturado` |
| Craft | quantity 1 (1–99) | dashed camera area; three material pills; selected image preview or built-in offline placeholder |
| Meal | type `Almoço da Floresta`, window `11:30`–`13:30`, portions 20 (1–100) | three type pills; start/end time controls; portion stepper |

The confirmation action is placed inside a safe-area bottom section, reports progress/error, disables duplicate submits while a write is in flight, pops only after success, and lets the controller notify the prior panel. Existing unavailable messages for these four primary buttons are replaced by navigation; unrelated voucher and passport actions remain unchanged.

### Persist image bytes through an abstraction, not a transient picker path

Add `image_picker` for the craft form. Read selected `XFile` bytes and store them in `craft_images`; set `photo_path` to a stable logical URI such as `hive://craft-images/<id>`. The renderer resolves that URI to bytes and uses `Image.memory`, which works on web and native builds. If the user skips image selection, persist `asset://craft-placeholder` and show a local icon-based placeholder. This avoids camera-cache paths that disappear after restart and web object URLs that are not persistent. Startup also checks the picker’s lost-data result on Android before exposing the form.

### Replace only provider demo data

Remove the `DemoDashboardData` dependency and local list copies from the four provider panels, and adapt their view models/cards to the new domain types. Retain tourist experience data until a separate change replaces that catalog; it is out of this change. Header text unrelated to the provider catalogs remains static, while list data and calculated metrics come from local records. Each panel gets loading, empty, error, and populated views so an initialization or storage failure does not masquerade as an empty catalog.

## Risks / Trade-offs

- [Local storage unavailable, corrupt, or a migration fails] → Initialize before the app UI, do not advance the schema version until success, show a retryable storage failure state, and keep migrations idempotent.
- [Image bytes make the browser database grow quickly] → Constrain picker dimensions/quality, store only one image per craft, and use a lightweight built-in placeholder where no photo is selected.
- [Android may destroy the activity while the camera intent is active] → Recover lost picker data at startup/form resume before treating capture as cancelled.
- [Desktop targets do not guarantee a system camera interface] → Offer gallery/file selection and render the capture affordance only where the platform source is supported.
- [Existing widgets/tests expect seeded static rows] → Replace them with fake repository/controller fixtures and tests that explicitly verify first-run empty state and persisted writes.
- [Prototype and Flutter dimensions can differ across screen sizes] → Use existing responsive widget conventions, semantic keys, and visual/widget tests at the prototype phone width before accepting the implementation.

## Migration Plan

1. Release schema version 1 with empty boxes and no demo-data import.
2. On first launch, bootstrap storage and expose the initialized controller before the login/root route is built.
3. Existing installations with no provider database behave as first installs; installations already on a compatible provider schema migrate sequentially without clearing data.
4. If initialization fails, preserve the stored version and records, show a recoverable error state, and do not write a partially migrated version.
5. Roll back application code only while it can read the current schema. No destructive downgrade is performed; user-directed clearing of app data remains the recovery path for an irrecoverable local store.
