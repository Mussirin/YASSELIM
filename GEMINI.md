# YASSELIM - Project Operational Rules & Commercial Standards

This repository is governed by strict commercial-readiness, store compliance, copyright safety, and high-performance architectural standards.

## 1. Non-Negotiable Directives
- **100% Commercial & Copyright Safety**:
  - Zero third-party copyrighted images, stock photos, or unlicensed icon sets.
  - All brand logos, mood icons, scenic thumbnails, and illustrations are authored from scratch as original Flutter `CustomPainter` vector graphics owned 100% by the project.
  - All daily writing prompts and UI texts in English and Turkish are 100% original compositions (no copyrighted quotes).
- **Zero Unverified Packages**: No pub dependency may be added without documenting its exact version and license in `THIRD_PARTY_LICENSES.md`. Only permissive licenses (MIT, BSD-3-Clause, Apache-2.0) are approved.
- **Strict Privacy & Offline-First**:
  - Personal journal entries and unsent letters are stored locally on the device using encrypted storage (AES-256 / SHA-256 key derivation).
  - Journal text is NEVER transmitted to advertising SDKs, analytics, or external servers.
  - No advertisements are ever rendered on the Writing Editor screen.
- **Modularity & ~100-Line Guideline**: Keep manually authored Dart files concise and modular by breaking complex screens into composable widgets and extracting business logic to Blocs/Cubits and Repositories.
- **Honest Test Execution**: Never declare that a test or lint passes without executing the exact command and verifying exit code 0.

## 2. Mandatory Quality Gate Commands
Before concluding any stage or task, run:
```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```
