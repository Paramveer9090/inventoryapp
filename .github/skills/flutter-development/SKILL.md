---
name: flutter-development
description: 'Develop, debug, test, and release Flutter applications. Use for Dart or Flutter changes, widget and controller bugs, GetX state management, PDF or platform integrations, responsive UI, analyzer failures, and Android or iOS build workflows.'
argument-hint: '[feature, bug, file, or build problem]'
user-invocable: true
---

# Flutter Development

## What This Skill Does

Use this workflow to make small, verifiable changes to a Flutter application while preserving existing architecture, state-management patterns, and uncommitted user work.

## Procedure

### 1. Establish the project context

- Read `pubspec.yaml` to identify the Flutter/Dart constraints, dependencies, assets, and available scripts.
- Check applicable repository instructions before editing.
- Inspect `git status` and preserve unrelated user changes. Never reset, stash, or revert work that was not explicitly requested.
- Identify the concrete anchor: a failing command, error, widget, controller, model, service, test, or build workflow.

### 2. Trace the owning code path

- Search for the visible label, error text, route, symbol, or command from the request.
- Follow wiring code to the nearest implementation that actually computes, mutates, renders, or controls the behavior.
- Read the owning method and its immediate callers, models, helpers, and neighboring tests.
- Form one falsifiable local hypothesis and name one cheap check that could disconfirm it before editing.

### 3. Make the smallest compatible change

- Prefer existing project abstractions, utilities, dependency versions, and state-management patterns.
- Preserve public APIs unless the request requires a contract change.
- Keep GetX reactive reads inside the smallest widget that directly consumes the Rx value; avoid wrapping unrelated widget trees.
- Reuse shared calculation and formatting helpers instead of duplicating business logic in views, PDFs, or export code.
- For UI changes, keep stable dimensions for tables, grids, toolbars, and controls; verify text does not wrap into unusable layouts on narrow screens.
- Do not add dependencies unless the existing SDK or a project dependency cannot reasonably solve the problem.
- Add comments only when the code would otherwise require non-obvious parsing.

### 4. Validate immediately after the first edit

Run the narrowest useful executable check before further exploration or patching:

```powershell
flutter analyze path/to/touched_file.dart
```

Then use the narrowest applicable checks:

```powershell
flutter test test/path/to_test.dart
flutter test
flutter format --set-exit-if-changed path/to/touched_file.dart
```

If no focused test exists, add or run a small behavior-scoped check. For a UI or PDF change, exercise the affected flow and inspect the rendered result rather than relying only on analyzer output.

### 5. Validate the app surface

Choose checks based on the change:

- Widget or layout: run the relevant widget test, then verify a representative desktop and mobile viewport.
- Controller, model, or calculation: test the input edge cases, null values, rounding, empty collections, and loading/error states.
- API or persistence: verify success, malformed data, missing optional fields, and retry/error behavior.
- PDF or export: verify column widths, line wrapping, totals, dates, missing data, and the generated file.
- Android: run `flutter build apk --release` or the project-specific release command.
- Web: run `flutter build web` when the web surface is affected.
- iOS from Windows: use the repository's macOS CI workflow; unsigned builds require local signing before device installation. Paid Apple Developer/TestFlight builds require signing credentials and provisioning profiles.

### 6. Finish cleanly

- Run `git diff --check` and review the final diff for scope, accidental formatting, secrets, and generated files.
- Report what changed, which validations passed, and any remaining limitation.
- Do not commit or push unless explicitly requested. If the user requests a GitHub Actions build, include only intended files and push the configured branch.

## Common Flutter Checks

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Use `dart format` for formatting when the repository does not provide a project-specific formatter command. Avoid broad cleanup while fixing a focused issue.

## Completion Criteria

A Flutter task is complete when:

- The controlling code path was identified and the change is minimal.
- The affected behavior has a focused validation result.
- Relevant edge cases and platform constraints were considered.
- No unrelated user changes were overwritten or included.
- The final diff is clean and the user knows how to verify the result.
