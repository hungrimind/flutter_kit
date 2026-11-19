# Customize your Theme

Having a consistent look and feel throughout your application will make it more professional and easier to use. Because of this, most of the styling for commonly used elements should be handled by the theme.

The default styling for this boilerplate is defined in `core/ui/theme/app_theme.dart`. Within this file we define what the app should look like for both light and dark mode.

## How to use

Because the theme is already applied on the `MaterialApp`, most of the colors, styling and similar is already applied automatically for you.

There are a lot of cases when this is not true though, such as when you define `Text('large text')` or when you want to have some spacing `SizedBox(height: 8)`. All these constants you would want to use is accessible through something called `ThemeExtension`.

To simplify this further we have exposed these as an extension on `BuildContext`.

```dart
// large text style
Text('large text', style: context.textStyle.xxl);

// Large grey/neutral text
Text('large text', style: context.textStyle.xxl.copyWith(color: context.kitColors.neutral500));

// Spacing
SizedBox(height: context.spacing.lg);
```

## Consistent UI

For most of the styling we use constants defined in `core/ui/constants/`. You can read more about the constants in the [UI Constants](../reference/utilities.md) section.

> [!TIP]
> **As you build**
>
> When developing, if something doesn't look how you want it to look, you should default to trying to update the general app theme. By doing this, your feature not only looks good now but for every future time you use it.
