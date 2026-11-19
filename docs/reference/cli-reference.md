# CLI Reference

The [Hungrimind CLI](https://github.com/hungrimind/hungrimind-cli) creates a new
Flutter project from this kit. It downloads the kit straight from GitHub, so no
account or login is needed.

### Install and requirements

Requires Node.js 18 or newer and the Flutter SDK.

Install globally from GitHub:

```sh
npm install -g github:hungrimind/hungrimind-cli
```

Verify the install:

```sh
hungrimind --version
```

### Basic usage

Get help:

```sh
hungrimind --help
hungrimind flutter --help
```

### Flutter

Create a new Flutter project:

```sh
hungrimind flutter create NAME --org com.mycompany
```

Use a lowercase, underscore-separated `NAME` (for example, `my_app`). The command
runs `flutter create`, applies the kit on top, renames `flutter_kit` to your
project name, and runs `flutter pub get`. `--org` defaults to `com.example`.

Then run it:

```sh
cd NAME
flutter run
```

See the [Guided Tour](../get-started/guided-tour.md) for a walkthrough.
