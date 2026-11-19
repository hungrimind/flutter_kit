# Hungrimind Flutter Boilerplate

> **Hungrimind has shut down.** This kit is now free and open to everyone. It is
> no longer actively maintained, but you are welcome to use it, fork it, and build on it.

## Overview

The Hungrimind Flutter Boilerplate is built for developers and teams who care about scalable, testable, and maintainable Flutter applications. Whether building solo or as part of a team, this boilerplate provides a solid foundation using the MVVM architecture and consistent patterns.

Crafted by the team at Hungrimind — with deep experience across Flutter, and large-scale app architecture — this boilerplate is here to help you ship high-quality apps, faster.

## What's Included

*   **💻 CLI:** Our [command line tool](https://github.com/hungrimind/hungrimind-cli) that creates a new app from this kit.
*   **🤖 Agent rules:** `CLAUDE.md`, `agents.md`, `.claude/skills/`, and `.cursor/rules/` describe the architecture and conventions for AI coding tools.

## Getting Started

You need [Flutter](https://docs.flutter.dev/get-started/install) and Node.js 18+ installed.

### With the CLI (recommended)

```bash
npm install -g github:hungrimind/hungrimind-cli
hungrimind flutter create my_app --org com.mycompany
cd my_app
flutter run
```

Replace `my_app` with your project name (lowercase with underscores) and
`com.mycompany` with your organization identifier.

The CLI runs `flutter create` for you, replaces the generated `lib/` and `test/`
with this kit's, copies the kit's config files (`analysis_options.yaml`, agent
rules, etc.) on top, merges the kit's `pubspec.yaml` into yours, renames
`flutter_kit` to your project name, adds network permissions on Android and
macOS, and runs `flutter pub get`.

### Without the CLI

1. Run `flutter create my_app --org com.mycompany`.
2. Delete the generated `lib/` and `test/`, then copy everything from this repo
   into `my_app/` except the platform folders (`android/`, `ios/`, `macos/`,
   `web/`, `linux/`, `windows/`) and `pubspec.yaml`.
3. Copy `environment`, `dependencies`, `dev_dependencies`, and the `flutter`
   section from this repo's `pubspec.yaml` into yours.
4. Find and replace `flutter_kit` with `my_app` (and `flutterKit` with `myApp`)
   across the copied files.
5. Add `<uses-permission android:name="android.permission.INTERNET"/>` to
   `android/app/src/main/AndroidManifest.xml`, and
   `<key>com.apple.security.network.client</key><true/>` to
   `macos/Runner/DebugProfile.entitlements`.
6. Run `flutter pub get`, then `flutter run`.

## Guiding Principles

### Minimal Dependencies
Every dependency you add is a liability that you need to work around. We believe in owning your code base and not depending on external libraries (as much as it makes sense). We only use the essential packages maintained by the Flutter or Dart team; the rest is native Flutter code.

### MVVM Architecture
There are many architectures and state management approaches. They can all work, but the more time you spend choosing and deliberating, the less time you spend building products. We use the MVVM Architecture, which has been battle-tested by us and recommended by the Flutter team.

### Own Your Code
This could have been a package, but we believe in owning your code. All these features are code that you can use, explore, and update for your use cases. (Let us know about your updates so we can potentially improve the boilerplate.)

### Align with the Flutter Team
Our goal is to align closely with the Flutter team's recommendations and best practices. When something is missing, we use our expertise to fill the gaps.
