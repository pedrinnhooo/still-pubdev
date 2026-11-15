import 'package:flutter/material.dart';
import 'package:still/still.dart';

void main() {
  runApp(const StillGalleryApp());
}

const _bg = Color(0xFF070B12);
const _surface = Color(0xFF101820);
const _ink = Color(0xFFE8F2FC);
const _mute = Color(0xFF8EA0B5);
const _line = Color(0xFF243140);
const _accent = Color(0xFF3EE0C5);
const _accentInk = Color(0xFF04221C);

class _Strings extends InheritedWidget {
  const _Strings({required this.english, required super.child});

  final bool english;

  static bool englishOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_Strings>();
    return scope?.english ?? true;
  }

  @override
  bool updateShouldNotify(_Strings oldWidget) => english != oldWidget.english;
}

String _tr(BuildContext context, String en, String pt) {
  return _Strings.englishOf(context) ? en : pt;
}

const _quotes = <(String, String)>[
  (
    'Motion should carry meaning, or get out of the way.',
    'O movimento deve carregar sentido ou sair do caminho.',
  ),
  ('A cross-fade is still a transition.', 'Um fade ainda é uma transição.'),
  (
    'The platform already asked. Most widgets never listened.',
    'A plataforma já pediu. A maioria dos widgets não escutou.',
  ),
];

/// Gallery used by `flutter run` and the example widget test.
class StillGalleryApp extends StatefulWidget {
  /// Creates the gallery.
  const StillGalleryApp({super.key});

  @override
  State<StillGalleryApp> createState() => _StillGalleryAppState();
}

class _StillGalleryAppState extends State<StillGalleryApp> {
  var _preference = MotionPreference.platform;
  var _quote = 0;
  var _generation = 0;
  var _english = true;

  @override
  Widget build(BuildContext context) {
    return MotionScope(
      preference: _preference,
      child: _Strings(
        english: _english,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'still',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: _bg,
            colorScheme: const ColorScheme.dark(
              primary: _accent,
              onPrimary: _accentInk,
              surface: _bg,
            ),
            visualDensity: VisualDensity.compact,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 14, height: 1.4, color: _ink),
              bodyMedium: TextStyle(fontSize: 13, height: 1.4, color: _ink),
              titleMedium: TextStyle(
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style:
                  FilledButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: _accentInk,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ).copyWith(
                    mouseCursor: const WidgetStatePropertyAll(
                      SystemMouseCursors.click,
                    ),
                  ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style:
                  OutlinedButton.styleFrom(
                    foregroundColor: _ink,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(color: _line),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                  ).copyWith(
                    mouseCursor: const WidgetStatePropertyAll(
                      SystemMouseCursors.click,
                    ),
                  ),
            ),
            iconButtonTheme: IconButtonThemeData(
              style:
                  IconButton.styleFrom(
                    foregroundColor: _ink,
                    visualDensity: VisualDensity.compact,
                  ).copyWith(
                    mouseCursor: const WidgetStatePropertyAll(
                      SystemMouseCursors.click,
                    ),
                  ),
            ),
            popupMenuTheme: PopupMenuThemeData(
              color: _surface,
              surfaceTintColor: Colors.transparent,
              elevation: 8,
              shadowColor: const Color(0xCC000000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: _line),
              ),
              textStyle: const TextStyle(color: _ink, fontSize: 13),
            ),
            tooltipTheme: TooltipThemeData(
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _line),
              ),
              textStyle: const TextStyle(color: _ink, fontSize: 12),
              waitDuration: const Duration(milliseconds: 500),
            ),
          ),
          home: Scaffold(
            body: Column(
              children: [
                _TopBar(
                  english: _english,
                  onSelect: (english) => setState(() => _english = english),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      const Positioned(top: -160, left: -80, child: _Glow()),
                      _PageFrame(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Intro(),
                            const SizedBox(height: 20),
                            Builder(
                              builder: (context) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: FilledButton(
                                    key: const Key('open-proposal'),
                                    onPressed: () => _openProposal(context),
                                    child: Text(
                                      _tr(
                                        context,
                                        'The proposal',
                                        'A proposta',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 44),
                            const _SectionLabel('00', 'Code', 'Código'),
                            const SizedBox(height: 8),
                            const _Bilingual(
                              en: 'One scope. Every widget below follows it.',
                              pt: 'Um escopo. Todos os widgets abaixo o seguem.',
                            ),
                            const SizedBox(height: 8),
                            const _CodeBlock(),
                            const SizedBox(height: 44),
                            _Playground(
                              preference: _preference,
                              onPreference: (preference) {
                                setState(() => _preference = preference);
                              },
                              quote: _quote,
                              onNextQuote: () {
                                setState(() {
                                  _quote = (_quote + 1) % _quotes.length;
                                });
                              },
                              generation: _generation,
                              onReplay: () => setState(() => _generation++),
                            ),
                          ],
                        ),
                      ),
                    ],
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

void _openProposal(BuildContext context) {
  final motion = MotionScope.of(context);
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fechar',
    barrierColor: const Color(0xD0000000),
    transitionDuration: motion.resolve(motion.scheme.medium),
    pageBuilder: (context, animation, secondary) => const _ProposalDialog(),
    transitionBuilder: (context, animation, secondary, child) {
      return StillTransition(
        animation: animation,
        motion: StillMotion.slideUp,
        travel: 48,
        child: child,
      );
    },
  );
}

class _ProposalDialog extends StatelessWidget {
  const _ProposalDialog();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 520, maxHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Material(
              color: _surface,
              elevation: 8,
              shadowColor: const Color(0xCC000000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: _line),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 20),
                child: StillStagger(
                  spacing: 22,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tr(context, 'PROPOSAL', 'PROPOSTA'),
                            style: const TextStyle(
                              color: _accent,
                              fontSize: 11,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          mouseCursor: SystemMouseCursors.click,
                          tooltip: _tr(context, 'Close', 'Fechar'),
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 18, color: _ink),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        _tr(
                          context,
                          'Motion that knows when to stop.',
                          'Movimento que sabe a hora de parar.',
                        ),
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: _CopyGroup(
                        blocks: [
                          _CopyBlock(
                            en: 'Flutter reports two different requests.',
                            pt: 'O Flutter informa dois pedidos diferentes.',
                          ),
                          _CopyBlock(
                            en: 'Reduce Motion, on iOS, asks for a cross-fade instead of a slide. The widget has to read that flag itself.',
                            pt: 'Reduzir movimento, no iOS, pede um fade no lugar do slide. O widget precisa ler essa opção.',
                          ),
                          _CopyBlock(
                            en: 'Remove animations, on Android, skips the animation. AnimationController follows that flag even if a MediaQuery tries to turn it back on.',
                            pt: 'Remover animações, no Android, pula a animação. O AnimationController segue essa opção mesmo que um MediaQuery tente ligá-la de novo.',
                          ),
                          _CopyBlock(
                            en: 'Flutter does not rewrite your slides. That choice belongs to the widget.',
                            pt: 'O Flutter não reescreve os seus slides. Essa escolha é do widget.',
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: _CopyGroup(
                        blocks: [
                          _CopyBlock(
                            en: 'still makes that choice once.',
                            pt: 'O still toma essa decisão uma vez.',
                          ),
                          _CopyBlock(
                            en: 'The switcher, the stagger, the entrance, and the page route follow it.',
                            pt: 'O seletor, a sequência, a entrada e a rota de página seguem essa decisão.',
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          _ModeGuide(
                            preference: MotionPreference.full,
                            en: 'Full',
                            pt: 'Completo',
                            detail: 'Slides, scale, and stagger run.',
                            detailPt:
                                'Há slide, escala e entrada em sequência.',
                          ),
                          SizedBox(height: 8),
                          _ModeGuide(
                            preference: MotionPreference.reduced,
                            en: 'Reduced',
                            pt: 'Reduzido',
                            detail:
                                'Travel is off. What remains is a cross-fade.',
                            detailPt:
                                'O deslocamento sai. O que resta é um fade.',
                          ),
                          SizedBox(height: 8),
                          _ModeGuide(
                            preference: MotionPreference.off,
                            en: 'Off',
                            pt: 'Desligado',
                            detail: 'Nothing animates. The next state is already there.',
                            detailPt: 'Nada se anima. O próximo estado já está na tela.',
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8, top: 8),
                      child: _AlertNote(
                        en: 'This panel entered with StillTransition. Change the mode and open it again.',
                        pt: 'Este painel entrou com StillTransition. Troque o modo e abra de novo.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          Material(
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
                      IconButton(
                        mouseCursor: SystemMouseCursors.click,
                        tooltip: _tr(context, 'Back', 'Voltar'),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const _BrandMark(),
                      const SizedBox(width: 10),
                      const Text(
                        'still',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          _tr(context, 'PAGE', 'PÁGINA'),
                          style: const TextStyle(
                            color: _mute,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: StillEntrance(
                    motion: StillMotion.slideUp,
                    child: const _Arrived(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Arrived extends StatelessWidget {
  const _Arrived();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _tr(context, 'In from the edge', 'Entrada pela borda'),
          style: const TextStyle(
            color: _ink,
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _tr(
            context,
            'This page used a short slide from the trailing edge. Reduce Motion fades it in. Remove animations shows it at once.',
            'Esta página usou um slide curto a partir da borda final. Reduzir movimento troca o slide por um fade. Remover animações mostra a página na hora.',
          ),
          style: const TextStyle(color: _mute, fontSize: 15, height: 1.45),
        ),
        const SizedBox(height: 22),
        const _RouteSketch(),
        const SizedBox(height: 28),
        Text(
          _tr(
            context,
            'Same route, three results',
            'A mesma rota, três resultados',
          ),
          style: const TextStyle(
            color: _ink,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        const _ModeGuide(
          preference: MotionPreference.full,
          en: 'Full',
          pt: 'Completo',
          detail: 'The page slides 64 pixels in from the trailing edge.',
          detailPt: 'A página desliza 64 pixels a partir da borda final.',
        ),
        const SizedBox(height: 8),
        const _ModeGuide(
          preference: MotionPreference.reduced,
          en: 'Reduced',
          pt: 'Reduzido',
          detail: 'The slide is dropped. The page fades in.',
          detailPt: 'O slide some. A página entra em fade.',
        ),
        const SizedBox(height: 8),
        const _ModeGuide(
          preference: MotionPreference.off,
          en: 'Off',
          pt: 'Desligado',
          detail: 'There is no travel and no fade. The page is already here.',
          detailPt: 'Não há deslocamento nem fade. A página já está aqui.',
        ),
        const SizedBox(height: 18),
        Text(
          _tr(
            context,
            'Go back, change the mode, and open this page again.',
            'Volte, troque o modo e abra esta página de novo.',
          ),
          style: const TextStyle(color: _mute, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }
}

class _RouteSketch extends StatelessWidget {
  const _RouteSketch();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tr(context, 'TRAILING EDGE', 'BORDA FINAL'),
                    style: const TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _tr(
                      context,
                      'The page behind stays visible for those 64 pixels.',
                      'A página anterior continua visível nesses 64 pixels.',
                    ),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const SizedBox(
              width: 88,
              height: 64,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _line,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(6),
                        ),
                      ),
                      child: SizedBox(width: 16),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF1B2838),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.fromBorderSide(
                          BorderSide(color: Color(0x883EE0C5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.english, required this.onSelect});

  final bool english;
  final ValueChanged<bool> onSelect;

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const _BrandMark(),
                  const SizedBox(width: 10),
                  const Text(
                    'still',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  _LanguageMenu(english: english, onSelect: onSelect),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageMenu extends StatelessWidget {
  const _LanguageMenu({required this.english, required this.onSelect});

  final bool english;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: const Color(0x1F3EE0C5),
        highlightColor: const Color(0x1F3EE0C5),
        splashColor: const Color(0x1F3EE0C5),
      ),
      child: PopupMenuButton<bool>(
        key: const Key('translate'),
        tooltip: english ? 'Language' : 'Idioma',
        onSelected: onSelect,
        color: _surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: const Color(0x99000000),
        offset: const Offset(0, 8),
        position: PopupMenuPosition.under,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 188),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: _line),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _LanguageOption(
                code: 'EN',
                name: 'English',
                selected: english,
              ),
            ),
            PopupMenuItem(
              value: false,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _LanguageOption(
                code: 'PT',
                name: 'Português',
                selected: !english,
              ),
            ),
          ];
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _line),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.public, size: 15, color: _accent),
                  const SizedBox(width: 8),
                  Text(
                    english ? 'EN' : 'PT',
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const ColoredBox(
                    color: _line,
                    child: SizedBox(width: 1, height: 12),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: _mute,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.code,
    required this.name,
    required this.selected,
  });

  final String code;
  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 164,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              code,
              style: TextStyle(
                color: selected ? _accent : _mute,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: _ink,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          if (selected) const Icon(Icons.check, size: 15, color: _accent),
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tr(context, 'GALLERY', 'GALERIA'),
          style: const TextStyle(
            color: _accent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _tr(
            context,
            'Motion that knows when to stop.',
            'Movimento que sabe a hora de parar.',
          ),
          style: const TextStyle(
            color: _ink,
            fontSize: 22,
            height: 1.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _tr(
            context,
            'A gallery of widgets that follow Reduce Motion and Remove animations. Open the proposal, pick a mode, and watch every demo follow it.',
            'Uma galeria de widgets que seguem as opções de reduzir movimento e de remover animações. Abra a proposta, escolha um modo e veja cada demonstração acompanhar.',
          ),
          style: const TextStyle(color: _mute, fontSize: 14, height: 1.45),
        ),
      ],
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

    // Ghost of the page behind: travel that is about to stop.
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

    // Arrived page: the slide settled, still on screen.
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

    // Fade, not travel: a soft fill inside the settled page.
    canvas.drawRRect(
      arrived.deflate(3.2),
      Paint()..color = const Color(0x553EE0C5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 420,
        height: 420,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0x553EE0C5), Color(0x003EE0C5)],
          ),
        ),
      ),
    );
  }
}

class _ModeBar extends StatelessWidget {
  const _ModeBar({required this.selected, required this.onSelect});

  final MotionPreference selected;
  final ValueChanged<MotionPreference> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final preference in MotionPreference.values)
          _ModeButton(
            preference: preference,
            selected: preference == selected,
            onTap: () => onSelect(preference),
          ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.preference,
    required this.selected,
    required this.onTap,
  });

  final MotionPreference preference;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final names = _preferenceNames(preference);
    final motion = MotionScope.of(context);
    final duration = motion.resolve(motion.scheme.fast);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: const Color(0x1F3EE0C5),
          child: AnimatedContainer(
            duration: duration,
            curve: motion.effect == MotionEffect.full
                ? Curves.easeOutCubic
                : Curves.linear,
            padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
            decoration: BoxDecoration(
              color: selected ? const Color(0x1F3EE0C5) : _surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selected ? _accent : _line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 15,
                  height: 15,
                  child: ClipRect(
                    child: StillSwitcher(
                      child: Icon(
                        _modeIcon(preference),
                        key: ValueKey('$preference-$selected'),
                        size: 15,
                        color: selected ? _accent : _mute,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _tr(context, names.$1, names.$2),
                  style: TextStyle(
                    color: selected ? _accent : _ink,
                    fontWeight: FontWeight.w700,
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

class _EffectReadout extends StatelessWidget {
  const _EffectReadout();

  @override
  Widget build(BuildContext context) {
    final effect = MotionScope.of(context).effect;
    final (label, en, pt) = _blurb(effect);
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _accent,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _tr(context, en, pt),
            style: const TextStyle(color: _ink, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _DriftRow extends StatelessWidget {
  const _DriftRow();

  @override
  Widget build(BuildContext context) {
    final effect = MotionScope.of(context).effect;
    final (en, pt) = switch (effect) {
      MotionEffect.full => (
        'The dot travels along the line. This clock is yours.',
        'A bolinha percorre a linha. Este relógio é seu.',
      ),
      MotionEffect.fade => (
        'Same clock, with travel forced to zero.',
        'O mesmo relógio, com o deslocamento zerado.',
      ),
      MotionEffect.none => (
        'Stopped. Remove animations skips the clock.',
        'Parado. Remover animações interrompe o relógio.',
      ),
    };
    return Row(
      children: [
        const SizedBox(width: 72, height: 28, child: _DriftTrack()),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _tr(context, en, pt),
            style: const TextStyle(color: _ink, height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _DriftTrack extends StatelessWidget {
  const _DriftTrack();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.centerLeft,
      children: [
        Positioned(
          left: 4,
          right: 4,
          top: 13,
          height: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF3A4D60),
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ),
        ),
        _Drift(),
      ],
    );
  }
}

class _Drift extends StatefulWidget {
  const _Drift();

  @override
  State<_Drift> createState() => _DriftState();
}

class _DriftState extends State<_Drift> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  MotionEffect? _effect;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final effect = MotionScope.of(context).effect;
    if (_effect == effect) return;
    _effect = effect;
    switch (effect) {
      case MotionEffect.full:
        _controller.repeat(reverse: true);
      case MotionEffect.fade:
      case MotionEffect.none:
        _controller.stop();
        _controller.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final travels = MotionScope.of(context).travels;
    const ball = 11.0;
    const travel = 56.0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dx = travels ? travel * _controller.value : 0.0;
        return Align(
          alignment: Alignment.centerLeft,
          child: Transform.translate(offset: Offset(dx, 0), child: child),
        );
      },
      child: const SizedBox(
        width: ball,
        height: ball,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _accent,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0xAA3EE0C5), blurRadius: 12)],
          ),
        ),
      ),
    );
  }
}

class _QuoteStage extends StatelessWidget {
  const _QuoteStage({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final english = _Strings.englishOf(context);
    final lines = [for (final quote in _quotes) english ? quote.$1 : quote.$2];
    return _Panel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const fontSize = 15.0;
          const style = TextStyle(
            color: _ink,
            fontSize: fontSize,
            height: 1.35,
            fontWeight: FontWeight.w600,
          );
          final direction = Directionality.of(context);
          final scaler = MediaQuery.textScalerOf(context);
          var height = fontSize;
          for (final line in lines) {
            final painter = TextPainter(
              text: TextSpan(text: line, style: style),
              textDirection: direction,
              textScaler: scaler,
            )..layout(maxWidth: constraints.maxWidth);
            if (painter.height > height) height = painter.height;
          }
          return SizedBox(
            height: height,
            width: double.infinity,
            child: ClipRect(
              child: StillSwitcher(
                child: Align(
                  key: ValueKey<String>(lines[index]),
                  alignment: Alignment.centerLeft,
                  child: Text(lines[index], style: style),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.title,
    required this.titlePt,
    required this.body,
    required this.bodyPt,
  });

  final String title;
  final String titlePt;
  final String body;
  final String bodyPt;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tr(context, title, titlePt),
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _tr(context, body, bodyPt),
            style: const TextStyle(color: _ink, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _CopyGroup extends StatelessWidget {
  const _CopyGroup({required this.blocks});

  final List<Widget> blocks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          blocks[i],
        ],
      ],
    );
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock({required this.en, required this.pt});

  final String en;
  final String pt;

  @override
  Widget build(BuildContext context) {
    return Text(
      _tr(context, en, pt),
      style: const TextStyle(color: _mute, fontSize: 13, height: 1.45),
    );
  }
}

class _AlertNote extends StatelessWidget {
  const _AlertNote({required this.en, required this.pt});

  final String en;
  final String pt;

  static const _amber = Color(0xFFE4C36A);
  static const _amberFill = Color(0x1AE4C36A);
  static const _amberLine = Color(0x55E4C36A);
  static const _amberInk = Color(0xFFEDE0B8);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _amberFill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _amberLine),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 1),
              child: Icon(Icons.warning_amber_rounded, size: 16, color: _amber),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _tr(context, en, pt),
                style: const TextStyle(
                  color: _amberInk,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeGuide extends StatelessWidget {
  const _ModeGuide({
    required this.preference,
    required this.en,
    required this.pt,
    required this.detail,
    required this.detailPt,
  });

  final MotionPreference preference;
  final String en;
  final String pt;
  final String detail;
  final String detailPt;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StillEntrance(
            motion: StillMotion.scale,
            child: Icon(_modeIcon(preference), size: 18, color: _accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tr(context, en, pt),
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _tr(context, detail, detailPt),
                  style: const TextStyle(
                    color: _mute,
                    fontSize: 13,
                    height: 1.35,
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

class _Bilingual extends StatelessWidget {
  const _Bilingual({required this.en, required this.pt});

  final String en;
  final String pt;

  @override
  Widget build(BuildContext context) {
    return Text(
      _tr(context, en, pt),
      style: const TextStyle(color: _ink, height: 1.4),
    );
  }
}

const _codePlain = Color(0xFFE6EDF3);
const _codeKeyword = Color(0xFFFF7B72);
const _codeType = Color(0xFFD2A8FF);
const _codeString = Color(0xFFA5D6FF);
const _codeProp = Color(0xFF79C0FF);

const _codeStyle = TextStyle(
  fontFamily: 'monospace',
  fontFamilyFallback: ['Menlo', 'Consolas', 'monospace'],
  fontSize: 12.5,
  height: 1.6,
  color: _codePlain,
);

const _codeSample = TextSpan(
  style: _codeStyle,
  children: [
    TextSpan(
      text: 'import',
      style: TextStyle(color: _codeKeyword),
    ),
    TextSpan(text: ' '),
    TextSpan(
      text: "'package:still/still.dart'",
      style: TextStyle(color: _codeString),
    ),
    TextSpan(text: ';\n\n'),
    TextSpan(
      text: 'MotionScope',
      style: TextStyle(color: _codeType),
    ),
    TextSpan(text: '(\n  preference: '),
    TextSpan(
      text: 'MotionPreference',
      style: TextStyle(color: _codeType),
    ),
    TextSpan(text: '.'),
    TextSpan(
      text: 'platform',
      style: TextStyle(color: _codeProp),
    ),
    TextSpan(text: ',\n  child: '),
    TextSpan(
      text: 'MaterialApp',
      style: TextStyle(color: _codeType),
    ),
    TextSpan(text: '(\n    home: '),
    TextSpan(
      text: 'StillSwitcher',
      style: TextStyle(color: _codeType),
    ),
    TextSpan(text: '(\n      child: '),
    TextSpan(
      text: 'Text',
      style: TextStyle(color: _codeType),
    ),
    TextSpan(text: '(line, key: '),
    TextSpan(
      text: 'ValueKey',
      style: TextStyle(color: _codeType),
    ),
    TextSpan(text: '(line)),\n    ),\n  ),\n)'),
  ],
);

class _CodeBlock extends StatelessWidget {
  const _CodeBlock();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ColoredBox(
              color: Color(0xFF161B22),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _WindowDot(Color(0xFFFF5F57)),
                    SizedBox(width: 6),
                    _WindowDot(Color(0xFFFEBC2E)),
                    SizedBox(width: 6),
                    _WindowDot(Color(0xFF28C840)),
                    SizedBox(width: 12),
                    Text(
                      'main.dart',
                      style: TextStyle(
                        color: Color(0xFF8B949E),
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFF30363D)),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: SelectableText.rich(_codeSample),
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Playground extends StatelessWidget {
  const _Playground({
    required this.preference,
    required this.onPreference,
    required this.quote,
    required this.onNextQuote,
    required this.generation,
    required this.onReplay,
  });

  final MotionPreference preference;
  final ValueChanged<MotionPreference> onPreference;
  final int quote;
  final VoidCallback onNextQuote;
  final int generation;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabBlock(
          index: '01',
          title: 'Motion',
          titlePt: 'Modo',
          detail: 'Pick a mode. Every demo below follows it.',
          detailPt:
              'Escolha um modo. Todas as demonstrações abaixo seguem o mesmo.',
          child: _MotionDeck(
            preference: preference,
            onPreference: onPreference,
          ),
        ),
        const SizedBox(height: 44),
        _LabBlock(
          index: '02',
          title: 'Switcher',
          titlePt: 'Troca',
          detail: 'The next sentence replaces this one. The key tells still it changed.',
          detailPt: 'A próxima frase substitui esta. A chave avisa o still de que ela mudou.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _QuoteStage(index: quote),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  key: const Key('next-quote'),
                  onPressed: onNextQuote,
                  child: Builder(
                    builder: (context) =>
                        Text(_tr(context, 'Next sentence', 'Próxima frase')),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 44),
        _LabBlock(
          index: '03',
          title: 'Stagger',
          titlePt: 'Sequência',
          detail: 'One clock, three notes. Later notes do not wait when motion is off.',
          detailPt: 'Um relógio e três notas. Sem movimento, as últimas não esperam a vez.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StillStagger(
                key: ValueKey<int>(generation),
                spacing: 12,
                children: const [
                  _Note(
                    title: 'Duration',
                    titlePt: 'Duração',
                    body: 'The fade keeps its duration. Off cuts it short.',
                    bodyPt: 'O fade mantém a duração. Desligado, ela acaba na hora.',
                  ),
                  _Note(
                    title: 'Travel',
                    titlePt: 'Deslocamento',
                    body: 'A slide becomes no slide, rather than a slower one.',
                    bodyPt: 'O slide some, em vez de ficar mais lento.',
                  ),
                  _Note(
                    title: 'Wait',
                    titlePt: 'Espera',
                    body: 'The pause between notes exists only while travel is on.',
                    bodyPt: 'A pausa entre as notas só existe enquanto o deslocamento está ligado.',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  key: const Key('replay-stagger'),
                  onPressed: onReplay,
                  child: Builder(
                    builder: (context) =>
                        Text(_tr(context, 'Replay', 'Repetir')),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 44),
        LayoutBuilder(
          builder: (context, constraints) {
            final sideBySide = constraints.maxWidth >= 680;
            final clock = _LabBlock(
              index: '04',
              title: 'Clock',
              titlePt: 'Relógio',
              detail:
                  'This loop is yours. still only turns the travel on or off.',
              detailPt: 'Este ciclo é seu. O still só liga ou desliga o deslocamento.',
              child: const _Panel(child: _DriftRow()),
            );
            final route = _LabBlock(
              index: '05',
              title: 'Page',
              titlePt: 'Página',
              detail: 'Opens from the trailing edge. Reduced motion fades in and drops the slide.',
              detailPt:
                  'Abre pela borda final. No modo reduzido, o slide vira fade.',
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  key: const Key('open-route'),
                  onPressed: () {
                    Navigator.of(context).push(
                      StillPageRoute<void>(builder: (_) => const _DetailPage()),
                    );
                  },
                  child: Text(_tr(context, 'Open page', 'Abrir página')),
                ),
              ),
            );
            if (!sideBySide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [clock, const SizedBox(height: 44), route],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: clock),
                const SizedBox(width: 20),
                Expanded(child: route),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MotionDeck extends StatelessWidget {
  const _MotionDeck({required this.preference, required this.onPreference});

  final MotionPreference preference;
  final ValueChanged<MotionPreference> onPreference;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ModeBar(selected: preference, onSelect: onPreference),
        const SizedBox(height: 12),
        const _EffectReadout(),
      ],
    );
  }
}

class _LabBlock extends StatelessWidget {
  const _LabBlock({
    required this.index,
    required this.title,
    required this.titlePt,
    required this.detail,
    required this.detailPt,
    required this.child,
  });

  final String index;
  final String title;
  final String titlePt;
  final String detail;
  final String detailPt;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x1F3EE0C5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                child: Text(
                  index,
                  style: const TextStyle(
                    color: _accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _tr(context, title, titlePt),
                style: const TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          _tr(context, detail, detailPt),
          style: const TextStyle(color: _mute, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final pad = width >= 1024
        ? 32.0
        : width >= 600
        ? 24.0
        : 16.0;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(pad, 28, pad, 32),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: child,
          ),
        ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.index, this.en, this.pt);

  final String index;
  final String en;
  final String pt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          index,
          style: const TextStyle(
            color: _accent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _tr(context, en, pt).toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _modeIcon(MotionPreference preference) {
  switch (preference) {
    case MotionPreference.platform:
      return Icons.devices_outlined;
    case MotionPreference.full:
      return Icons.swipe_outlined;
    case MotionPreference.reduced:
      return Icons.opacity_outlined;
    case MotionPreference.off:
      return Icons.motion_photos_off_outlined;
  }
}

(String, String) _preferenceNames(MotionPreference preference) {
  switch (preference) {
    case MotionPreference.platform:
      return ('Platform', 'Plataforma');
    case MotionPreference.full:
      return ('Full', 'Completo');
    case MotionPreference.reduced:
      return ('Reduced', 'Reduzido');
    case MotionPreference.off:
      return ('Off', 'Desligado');
  }
}

(String, String, String) _blurb(MotionEffect effect) {
  switch (effect) {
    case MotionEffect.full:
      return (
        'TRAVEL',
        'Travel is on. Slides, scale, and stagger run.',
        'O deslocamento está ligado. Há slide, escala e entrada em sequência.',
      );
    case MotionEffect.fade:
      return (
        'FADE',
        'Travel is off. What remains is a cross-fade.',
        'O deslocamento sai. O que resta é um fade.',
      );
    case MotionEffect.none:
      return (
        'CUT',
        'Nothing animates. The next state is already there.',
        'Nada se anima. O próximo estado já está na tela.',
      );
  }
}
