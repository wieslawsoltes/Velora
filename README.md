# Velora Design Studio

[GitHub Pages editor](https://wieslawsoltes.github.io/Velora/) · [Hosted collaborative workspace](https://velora-design-studio.wisodev.chatgpt.site)

## GitHub Pages edition

The Pages deployment is the full static editor with IndexedDB storage on the current browser/device. Designs, uploads, folders, favorites, personal comments, and version snapshots survive reloads in that browser. The saved indicator explicitly says **Saved on this device**. It does not claim cloud persistence or cross-device collaboration. Clearing browser site data removes local designs; export portable design packages for backups.

The Share button exports an editable portable JSON package containing the document and uploaded media. Importing that package remaps asset identifiers into the receiving browser. PNG, JPEG, PDF, SVG, and slideshow WebM exports remain available. The Share dialog also links to the hosted collaborative workspace, which has its own sign-in and access policy. GitHub Pages cannot run the included Worker API, D1 database, or R2 storage.

Build the Pages edition without installing dependencies:

```sh
node scripts/build-pages.mjs
python -m http.server 8080 --directory pages-dist
```

Open the URL served by that command. The output is **pages-dist/**. All editor and image paths work beneath `/Velora/` as well as at the domain root. `.github/workflows/pages.yml` validates the static edition and deploys it on every push to `main`, with manual dispatch also supported. Configure repository Settings → Pages → Source as **GitHub Actions**.

The complete server implementation, schema, migrations, tests, and hosting integration are retained below. The cloud deployment is independent of the GitHub Pages static deployment.

Velora is an original browser design workspace for editable presentations, social graphics, posters, documents, and custom-size canvases. Its editor is implemented in plain HTML, CSS, and native JavaScript modules. The hosting wrapper and authenticated HTTP endpoints use the bundled Vinext/Cloudflare Worker integration; the editor does not use a frontend framework.

## Run and validate

Requires Node 22.13 or later and the package manager pinned in `package.json`.

```sh
pnpm install
pnpm dev
node --test tests/*.test.mjs
pnpm build
```

The app requires D1 (`DB`) and R2 (`BUCKET`) for durable projects and uploaded media. Configure these logical bindings through `.openai/hosting.json`. Schema lives in `db/schema.ts`; generated migrations live in `drizzle/`. Apply migrations before starting a new deployment. Authentication uses the host's ChatGPT sign-in and verified identity headers. Never expose a development server directly to the Internet or trust arbitrary client-supplied identity headers outside the platform dispatcher.

The managed execution profile uses the supplied build and preview scripts. For portable local setup, the supplied runtime scripts detect the execution profile and support the bundled loopback-only mock authentication. See `scripts/`, `vite.config.ts`, and `app/chatgpt-auth.ts`.

## Editor

- Editable scene graph with immutable IDs, pages, text, rectangles, ellipses, triangles, lines/arrows, images, videos, freehand paths, and bar charts.
- Dragging, eight resize grips, rotation, inverse-transform hit testing, multiselection, marquee selection, groups, exact geometry, page alignment, center/edge snapping, stacking, lock/hide, duplicate, delete, and keyboard commands.
- In-place text editing, font family and size, bold/italic, paragraph alignment, color, and opacity.
- Nondestructive image crop/zoom/offset, flips, brightness, contrast, saturation, blur, and rounded corners.
- Six editable templates and three original generated campaign photographs.
- Multipage management with thumbnails, drag reordering, duplication, deletion, notes, timing, presentation mode, and autoplay.
- Project search, folders, favorites, duplication, trash, saved snapshots, and import/export of the editable JSON format.
- Saved per-project brand colors and font metadata, palette application, and typography presets.
- Light/dark themes, responsive tool panels, focus states, native dialogs, keyboard controls, and WebMCP feature detection.

## Rendering architecture

`public/studio/model.js` is the canonical model, validator, operation reducer, geometry, and history implementation. `renderer.js` owns shared drawing and export paths. `app.js` owns controls and gesture transactions. `sync.js` owns the acknowledged server snapshot, pending queue, and reconciliation.

WebGPU draws basic rectangles, ellipses, and triangles directly using WGSL. It composites cached per-element raster textures for text, images, paths, charts, effects, and video. Translation/rotation/opacity updates reuse those textures. Content changes invalidate the relevant object cache. Off-page elements are culled. Texture resolution adapts to an approximate 96 MiB raster budget, and old GPU resources are explicitly destroyed. A Canvas 2D fallback is provided when WebGPU is unavailable or its device is lost.

This is a hybrid renderer, not a GPU text-shaping engine. Browser Canvas 2D supplies text layout and complex rasterization. Different operating-system fonts can produce different metrics. Diagnostics in the lower right report the actual backend, render time, object count, and cache count.

## Durable state and collaboration

D1 stores projects, revisions, operation receipts, memberships, share grants, comments, presence, media metadata, and named snapshots. R2 stores uploaded media bytes. Browser session storage is used only to recover unacknowledged pending edits; the database remains authoritative.

Each mutation has a random idempotency identifier. The server applies property-level operations to the latest snapshot with revision compare-and-swap and an atomic D1 batch. Operation retries are deduplicated. The client polls every 1.5 seconds, preserves pending changes over remote snapshots, rejects older responses, and isolates project-switch requests. Presence updates are throttled to 3.5 seconds and expire after 20 seconds.

Separate object properties can merge. Changes to the same property use server acceptance order. A text element's content is one property; this is not character-level collaborative rich text. Undo avoids replacing a property that has visibly changed since the local action, but is not a full intention-preserving CRDT undo system. Ordering operations preserve stable IDs with deterministic handling of unseen IDs; complex concurrent reorder intent is not inferred.

Server-side authorization supports owner, editor, commenter, and viewer roles. Share capabilities are random, stored as SHA-256 hashes, and revocable. Media access is checked against its project. Duplicating a design copies its stored media into the new project's access scope. Collaborators must also satisfy the hosting platform's site-level audience restrictions. Initial publication is owner-private; an in-app share link does not override that outer restriction. Adding a collaborator grants access but sends no email.

## Export formats

| Format | Behavior |
| --- | --- |
| PNG / JPEG | Current selected page at 1× or 2×, subject to a 40-megapixel guard. |
| PDF | All pages, rasterized at 1.5× and embedded as JPEG in a real multipage PDF. No selectable text or print-production color management. |
| SVG | Text, rectangles, ellipses, and triangles remain SVG elements. Other content is embedded as raster data. Validated and self-contained. |
| Velora JSON | Complete editable document model. Stored media URLs remain tied to authenticated server assets; portability to a different server requires migrating those assets. |
| WebM | Real browser MediaRecorder output of timed page images. Real-time export duration equals page durations. No multitrack audio mix or frame-accurate source-video export. |

## Validation

56 automated tests cover model round trips, transforms, schema rejection, safe known-state undo, revision races, project switching, pending replay, API authorization, concurrent operations, operation deduplication, comments, version snapshots, link revocation, and media ownership when duplicating projects. API tests run the actual route logic against Node SQLite and an in-memory R2 adapter; they do not certify Cloudflare production behavior.

All six template scenes were rendered using the same Canvas drawing functions with a native test canvas. PNG, standalone SVG, and a three-page PDF were generated; PDF structure/page count were inspected.

The local adapter and portable package workflows have additional tests. Actual browser IndexedDB quota/eviction behavior remains unverified. Browser interaction tests, mobile hardware, a physical WebGPU adapter, live two-account synchronization, MediaRecorder browser codecs, and WebMCP registration in a supported browser were not exercised in this environment. See `docs/CAPABILITIES.md` for the remaining product scope.
