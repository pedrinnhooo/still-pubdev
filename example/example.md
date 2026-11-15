Paste this into `lib/main.dart` and run it. `HomePage` is the screen from `main`. Open the second page, then use **Back**.

```dart
import 'package:flutter/material.dart';
import 'package:still/still.dart';

void main() {
  runApp(const StillApp());
}

const _bg = Color(0xFF070B12);
const _surface = Color(0xFF101820);
const _ink = Color(0xFFE8F2FC);
const _mute = Color(0xFF8EA0B5);
const _line = Color(0xFF243140);
const _accent = Color(0xFF3EE0C5);
const _accentInk = Color(0xFF04221C);

class StillApp extends StatefulWidget {
  const StillApp({super.key});

  @override
  State<StillApp> createState() => _StillAppState();
}

class _StillAppState extends State<StillApp> {
  var _preference = MotionPreference.platform;

  @override
  Widget build(BuildContext context) {
    return MotionScope(
      preference: _preference,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _bg,
          colorScheme: const ColorScheme.dark(
            primary: _accent,
            onPrimary: _accentInk,
            surface: _bg,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: _accentInk,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        home: HomePage(
          preference: _preference,
          onPreference: (preference) {
            setState(() => _preference = preference);
          },
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.preference,
    required this.onPreference,
  });

  final MotionPreference preference;
  final ValueChanged<MotionPreference> onPreference;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _status = 'Preparing';
  var _generation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _Bar(title: 'still'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              children: [
                const Text(
                  'GALLERY',
                  style: TextStyle(
                    color: _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const StillEntrance(
                  motion: StillMotion.slideUp,
                  child: Text(
                    'Motion that knows when to stop.',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'One scope. Every widget on this page follows it.',
                  style: TextStyle(color: _mute, fontSize: 14, height: 1.45),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final preference in MotionPreference.values)
                      _ModeChip(
                        label: preference.name,
                        selected: preference == widget.preference,
                        onTap: () => widget.onPreference(preference),
                      ),
                  ],
                ),
                const SizedBox(height: 28),
                _Panel(
                  child: StillSwitcher(
                    child: Text(
                      _status,
                      key: ValueKey(_status),
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        _status = _status == 'Preparing'
                            ? 'On the way'
                            : 'Preparing';
                      });
                    },
                    child: const Text('Next status'),
                  ),
                ),
                const SizedBox(height: 28),
                StillStagger(
                  key: ValueKey('${widget.preference}-$_generation'),
                  spacing: 12,
                  children: const [
                    _Note(
                      title: 'Duration',
                      body: 'The fade keeps its time. Off cuts it short.',
                    ),
                    _Note(
                      title: 'Travel',
                      body: 'The slide drops out. It does not get slower.',
                    ),
                    _Note(
                      title: 'Wait',
                      body: 'The pause between notes exists only while travel is on.',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _generation++),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _ink,
                      side: const BorderSide(color: _line),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Replay'),
                  ),
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        StillPageRoute<void>(
                          builder: (_) => const DetailPage(),
                        ),
                      );
                    },
                    child: const Text('Open page'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _Bar(
            title: 'still',
            leading: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: _ink),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
              children: const [
                StillEntrance(
                  motion: StillMotion.slideUp,
                  child: Text(
                    'In from the edge',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'This page slid in from the trailing edge. Use Back to return, change the mode, and open it again.',
                  style: TextStyle(color: _mute, fontSize: 15, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.title, this.leading});

  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _bg,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _line)),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                if (leading != null) leading! else const SizedBox(width: 16),
                if (leading != null) const SizedBox(width: 8),
                const _BrandMark(),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 26,
      height: 26,
      child: CustomPaint(painter: _BrandPainter()),
    );
  }
}

class _BrandPainter extends CustomPainter {
  const _BrandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const accent = Color(0xFF3EE0C5);
    const radius = Radius.circular(5);

    final behind = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.04,
        size.height * 0.18,
        size.width * 0.58,
        size.height * 0.64,
      ),
      radius,
    );
    canvas.drawRRect(
      behind,
      Paint()
        ..color = const Color(0x663EE0C5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    final arrived = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.28,
        size.height * 0.08,
        size.width * 0.66,
        size.height * 0.84,
      ),
      radius,
    );
    canvas.drawRRect(arrived, Paint()..color = const Color(0xFF0C1A16));
    canvas.drawRRect(
      arrived,
      Paint()
        ..color = accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawRRect(
      arrived.deflate(3.2),
      Paint()..color = const Color(0x553EE0C5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0x1F3EE0C5) : _surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: selected ? _accent : _line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _accent : _ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(color: _ink, height: 1.35)),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );
  }
}
```
