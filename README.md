# still

Motion that knows when to stop.

Wrap the app once. When the platform asks for Reduce Motion, slides become a cross-fade. When it asks to remove animations, the next state is already on screen. Every widget under that wrap follows the same decision.

## What Flutter leaves to you

Flutter already records Reduce Motion (iOS) and Remove animations (Android). It stores the flag and stops there.

`AnimationController` ignores Reduce Motion on purpose. The framework wants a cross-fade instead of a shorter slide, and that choice belongs to each widget. A card that enters from below still enters from below for someone who asked the motion to stop.

Remove animations is a separate flag. `AnimationController` snaps to the end by itself. Reduce Motion has no equivalent.

| Situation | Flutter | `still` |
| --- | --- | --- |
| Reduce Motion is on | The slide keeps traveling. Each animation reads the flag on its own. | Travel, scale, and stagger become zero. What remains is a cross-fade. |
| Remove animations is on | The controller snaps to the end. A stagger can still leave later children waiting. | Duration and the wait between children become zero. The next state is already there. |
| You want to see all three results | Change the operating system setting. | Set `preference` on `MotionScope` to `reduced`, `off`, or `full`. |
| The app has its own design system | Page transitions live on Material. Flutter 3.50 moves Material out of the SDK. | The package never imports Material. The same widgets run under `WidgetsApp`. |

The package depends only on the Flutter widgets library, so a design system can respect the accessibility flag without importing one.

## Use it

Add the dependency in the app `pubspec.yaml`:

```yaml
dependencies:
  still: ^0.1.0
```

Until this is published, point `path` at the package directory:

```yaml
dependencies:
  still:
    path: ../still
```

In `main.dart`, wrap the app once. `MotionScope` is the parent of `MaterialApp` or `WidgetsApp`. One wrap covers every screen under it.

```dart
import 'package:flutter/material.dart';
import 'package:still/still.dart';

void main() {
  runApp(
    const MotionScope(
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

`WidgetsApp` takes the same parent. Pass `preference: MotionPreference.reduced` (or `off`, or `full`) to preview a mode without changing the system setting.

Then put a widget where the motion already is:

- A line or card that swaps, where you would use `AnimatedSwitcher`: `StillSwitcher`. Give each distinct child its own `Key`.
- Something that enters once, such as a card when the screen opens: `StillEntrance`. Change the `Key` to play it again.
- A list that arrives in sequence: `StillStagger`. With travel off, later children appear together.
- A new screen: `StillPageRoute` in place of `MaterialPageRoute`. The push travels 64 logical pixels from the trailing edge.
- An animation you already wrote: read `MotionScope.of(context).travels` and multiply your offset by it. The clock stays yours.

Samples for each one are below.

## What the flags do

| Signal | What `still` does |
| --- | --- |
| Reduce Motion | Cross-fade. Travel, scale, and stagger become zero. The duration stays, so the fade is visible. |
| Remove animations | No animation. The next state is already there. |
| `MotionPreference.reduced` | The same cross-fade, forced. Useful in tests and in a preview toggle. |
| `MotionPreference.off` | The same cut, forced. |
| `MotionPreference.full` | Travel stays on even if Reduce Motion is on. |

Remove animations is also read by `AnimationController` itself, and a `MediaQuery` cannot turn that engine flag off. `MotionPreference.full` does not override it either. On a device with animations removed, controllers still snap to the end.

On Flutter 3.47 and earlier, Reduce Motion is read from `AccessibilityFeatures.reduceMotion`. Flutter 3.50 adds `MediaQueryData.reduceMotion`, which widgets can override. `MotionScope` reads that field when the SDK has it and falls back when it does not, so the same code runs before and after the upgrade.

## Widgets

`StillSwitcher` needs a `Key` on each distinct child, same as `AnimatedSwitcher`.

```dart
StillSwitcher(
  child: Text(line, key: ValueKey(line)),
)
```

`StillEntrance` plays once. Change its `Key` to play it again.

```dart
StillEntrance(
  motion: StillMotion.slideUp,
  child: const CardBody(),
)
```

`StillStagger` uses one clock. When travel is dropped, later children do not sit there waiting for a stagger that was cancelled.

```dart
StillStagger(
  children: const [Note(title: 'Duration'), Note(title: 'Travel')],
)
```

`StillPageRoute` pushes from the trailing edge by 64 logical pixels. Pop uses the short duration.

```dart
Navigator.of(context).push(
  StillPageRoute<void>(builder: (_) => const DetailPage()),
);
```

For an animation you already wrote, read the decision and zero the travel yourself:

```dart
final motion = MotionScope.of(context);
final dx = motion.travels ? 16 * controller.value : 0.0;
```

## Testing

Force the decision. You do not need to change the operating system setting.

```dart
await tester.pumpWidget(
  const MotionScope(
    preference: MotionPreference.reduced,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: MyScreen(),
    ),
  ),
);
```

Or drive the platform flags:

```dart
tester.platformDispatcher.accessibilityFeaturesTestValue =
    const FakeAccessibilityFeatures(reduceMotion: true);
```

`MediaQueryData(disableAnimations: true)` above the scope is the Remove animations override.

## Example

The gallery in `example/` toggles Platform, Full, Reduced, and Off on a switcher, a stagger, a hand-written loop, and a page route.

```bash
cd example
flutter run -d macos
flutter run -d chrome
```

Widget previews for the three effects live in `example/lib/previews.dart`.

## Package skill

`skills/still/SKILL.md` ships with the package. After publication, an app that depends on `still` can pick it up with `dart run skills@ get`. That is the Flutter 3.50 layout for skills published inside a pub.dev package.

## License

BSD 3-Clause. Copyright 2026 Pedro Ruffo.
