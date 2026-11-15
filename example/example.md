Paste this into `lib/main.dart` and run it. `main` opens `HomePage`. The `Still` widgets live on that page, so you can tap and see each one.

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _line = 'Preparing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const StillEntrance(
              motion: StillMotion.slideUp,
              child: Text(
                'Order',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            StillSwitcher(
              child: Text(_line, key: ValueKey(_line)),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                setState(() {
                  _line = _line == 'Preparing' ? 'On the way' : 'Preparing';
                });
              },
              child: const Text('Next status'),
            ),
            const SizedBox(height: 24),
            const StillStagger(
              children: [
                Text('Duration'),
                Text('Travel'),
                Text('Wait'),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  StillPageRoute<void>(
                    builder: (_) => const DetailPage(),
                  ),
                );
              },
              child: const Text('Open page'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: StillEntrance(
            motion: StillMotion.slideUp,
            child: Text('In from the edge'),
          ),
        ),
      ),
    );
  }
}
```
