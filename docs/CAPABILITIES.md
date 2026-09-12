# Capability boundaries

Velora implements a substantial design editor and server-backed project workflow. It does not implement every feature of a large commercial visual suite. UI controls route to the described actions; a menu entry or output filename is not treated as proof of feature parity.

## Implemented

The README describes the implemented editor, rendering, persistence, authorization, comments, collaboration protocol, templates, and export formats. Users can create a design, edit actual scene objects, save/reload, manage pages, invite authenticated collaborators, leave comments, and export artifacts. Failed saves preserve pending edits and show a visible state. Imported scene properties are checked before acceptance, including numeric bounds and media URL restrictions. SVG output validates inputs before serialization.

## Material remaining work

- Character-level rich-text collaboration, intention-preserving CRDT/OT semantics, asynchronous presence push, conflict inspection, and comprehensive distributed stress/latency testing. Current transport is HTTP polling; it is not a WebSocket service.
- Rich text spans, text on paths, complete typography shaping controls, custom font upload/licensing, vector path point editing, Boolean geometry, SVG/PDF/PPTX/DOCX import, exact third-party file compatibility, and deeply nested scene groups.
- Professional video timeline, frame-accurate trim/split, transitions/keyframe animation, audio waveform editing/mixing, captioning, MP4 encoding, and audio in exported video. Uploaded videos play in presentation mode; uploaded audio can be previewed.
- Background segmentation/removal, text-to-image/video, generative layouts, language-model writing, and other AI services. There is no fake AI endpoint. Templates and palettes are deterministic editable assets.
- Full spreadsheets, spreadsheet formula engine, whiteboard infinite canvas, website publishing, email builders, print ordering, asset marketplace, brand approvals, and enterprise workflow policies.
- External public account registration, SSO/SCIM, billing, org administration, email delivery, app marketplace, third-party integrations, production quotas/rate limits, retention cleanup, monitoring, backups/restoration, and external security review.
- Accessibility for every canvas operation through a screen reader; the layers panel and keyboard controls provide alternatives, but the free-form canvas is not a certified accessible editor.
- Physical-GPU validation, text raster atlas batching, worker-based heavy geometry/export, production-scale benchmarks, and exhaustive memory-pressure/device-loss testing. Native shapes use WebGPU, while text/media are raster textures.
- Device-independent font embedding and color fidelity, CMYK/ICC print workflows, vector PDF, editable Office exports, font portability, and independent offline asset packages.

## Current intentional constraints

Maximum 100 pages, 2,000 elements per page, 2 MB serialized design payload, 25 MB per uploaded file, 8,192 px page dimension, 20,000 points per freehand path, 20 chart values, and 1–120 seconds per page. Controls and imports must respect these limits. Saved designs require authenticated D1/R2 access. Anonymous exploration can be exported but is not silently represented as a cloud save.

The initial deployment is private to its owner. In-app collaborator grants are enforced in addition to the site audience; other people need site-level access before a project link can admit them.

## GitHub Pages deployment

The GitHub Pages edition uses IndexedDB for device-local designs, media, snapshots, and personal notes. It has no authenticated cloud API or cross-device collaboration. Its Share dialog exports portable editable packages containing uploaded media and links to the independent hosted workspace. The original authenticated server implementation is included in the repository. Pages routing and assets are derived from module-relative URLs, so project subpaths and custom domains work. Portable files have a 60 MB media export limit and 90 MB file import limit, with the existing 25 MB per-media-file and 2 MB document model limits.
