# UI Constants

## KitColors

It's just as important to have a consistent color palette. Our favourite color is the [Neutral Colors from Tailwind CSS](https://tailwindcss.com/docs/colors) (you can see it used thoughout all of Hungrimind).

There is a utility class called `KitColors` that contains all the shades of the neutral colors and other colors that might be relevant for you.

The colors in the theme class will be inverted correctly depending on the current theme.

```dart
// example.dart
context.kitColors.neutral500
context.kitColors.red500
context.kitColors.green500
context.kitColors.yellow500
```

## Consistent UI

For your apps to have a professional look and feel, it is important to have a consistent UI. We have created a set of utility classes to help you create a consistent UI.

> ✅ **TIP**
>
> All of these are accessible through extensions on the `BuildContext`.

### AppSpacing

The `AppSpacing` class helps you to create consistent spacing between your UI elements.

```dart
// example.dart
context.spacings.xxs
context.spacings.xs
context.spacings.sm
context.spacings.md
context.spacings.lg
context.spacings.xl
context.spacings.xxl
```

### BorderRadius

The `BorderRadius` class helps you to create consistent border radii.

```dart
// example.dart
context.borderRadius.none
context.borderRadius.sm
context.borderRadius.md
context.borderRadius.lg
context.borderRadius.lg
context.borderRadius.xxl
context.borderRadius.xxxl
context.borderRadius.full
```

### Breakpoints

The `Breakpoints` class helps you to create responsive UI.

```dart
// example.dart
context.breakpoints.sm
context.breakpoints.md
context.breakpoints.lg
context.breakpoints.xl
context.breakpoints.xxl
```

### Durations

The `Durations` class helps you to create consistent durations.

```dart
// example.dart
context.durations.duration75
context.durations.duration100
context.durations.duration150
context.durations.duration200
context.durations.duration300
context.durations.duration500
context.durations.duration700
context.durations.duration1000
```

### Shadows

The `Shadows` class helps you to create consistent shadows.

```dart
// example.dart
context.shadows.sm
context.shadows.md
context.shadows.lg
context.shadows.xl
context.shadows.xxl
```

### Text Styles

The `TextStyles` class helps you to create consistent text styles.

```dart
// example.dart
context.textStyles.xs
context.textStyles.sm
context.textStyles.standard
context.textStyles.lg
context.textStyles.xl
context.textStyles.xxl
context.textStyles.xxxl
```
