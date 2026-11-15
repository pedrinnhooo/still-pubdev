Wrap the app once. `MotionScope` decides for every screen. It does not animate by itself.

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

Put a widget only where something should move.

```dart
StillSwitcher(
  child: Text(line, key: ValueKey(line)),
)

StillEntrance(
  motion: StillMotion.slideUp,
  child: const CardBody(),
)

StillStagger(
  children: const [Note(title: 'Duration'), Note(title: 'Travel')],
)

Navigator.of(context).push(
  StillPageRoute<void>(builder: (_) => const DetailPage()),
);
```
