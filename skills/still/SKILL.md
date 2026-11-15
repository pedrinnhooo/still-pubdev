---
name: still
description: >
  Use when adding, changing, or reviewing Flutter motion so slides, scales,
  staggers, and page routes respect Reduce Motion and Remove animations.
  Prefer the still package (MotionScope, StillSwitcher, StillEntrance,
  StillStagger, StillPageRoute) over a raw SlideTransition or a hard-coded
  Duration.
---

# still

`still` resolves platform motion into one decision and applies it to transitions. It does not depend on Material.

## When this applies

- A new slide, scale, stagger, shared-axis transition, or page push is being added.
- An existing animation ignores the Reduce Motion or Remove animations setting.
- A test needs to show the reduced and off variants without changing the OS setting.

Do not use it for motion that is the product, such as a game or a progress that encodes state. Those can stay on `MotionPreference.full` for that subtree only.

## Set up

Wrap the app once, above `WidgetsApp` or `MaterialApp`:

```dart
MotionScope(
  child: app,
)
```

Read the decision with `MotionScope.of(context)`.

| `Motion.effect` | What to render |
| --- | --- |
| `MotionEffect.full` | The authored slide, scale, or stagger. |
| `MotionEffect.fade` | Opacity only. Keep the duration. Set travel and stagger delay to zero. |
| `MotionEffect.none` | Show the resting state. Duration is `Duration.zero`. |

`motion.travels` is true only for `MotionEffect.full`. `motion.resolve(duration)` returns `Duration.zero` when the effect is `none`.

## Prefer the built-in widgets

- Swapping two children: `StillSwitcher`. Each distinct child needs its own `Key`.
- A widget appearing: `StillEntrance`. Change the `Key` to replay.
- A list arriving together: `StillStagger`. Do not delay later children yourself; the widget drops the stagger when travel is off.
- A route: `StillPageRoute`. Default travel is 64 logical pixels from the trailing edge.

## Hand-written controllers

```dart
final motion = MotionScope.of(context);
final dx = motion.travels ? scheme.travel * (1 - t) : 0.0;
```

Do not read `MediaQuery.disableAnimations` in a widget that already sits under `MotionScope`. The scope has already combined that flag with Reduce Motion.

## Tests

```dart
await tester.pumpWidget(
  MotionScope(
    preference: MotionPreference.reduced,
    child: const Directionality(
      textDirection: TextDirection.ltr,
      child: MyScreen(),
    ),
  ),
);
```

`MotionPreference.off` is the cut. `FakeAccessibilityFeatures(reduceMotion: true)` covers the platform path.

`MotionPreference.full` does not override the engine's Remove animations flag. `AnimationController` still snaps to the end while that flag is on.
