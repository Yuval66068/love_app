import 'dart:math';
import 'package:flutter/material.dart';

// Simple, single-file Flutter app implementing the spec.
// Change texts/colors near the top of build methods or in ThemeData.

void main() {
  runApp(const LoveApp());
}

class LoveApp extends StatelessWidget {
  const LoveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFEAF0), // soft pink
      ),
      home: const LandingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  bool _opening = false;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapEnvelope() async {
    if (_opening) return;
    setState(() => _opening = true);
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LetterScreen()),
    );
    // reset when returning
    setState(() => _opening = false);
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD7E0), Color(0xFFFFB6D5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              const Text(
                'יש לי משהו לשאול אותך...',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _onTapEnvelope,
                child: EnvelopeWidget(controller: _controller),
              ),
              const SizedBox(height: 12),
              const Text('לחצי על המכתב 💌', style: TextStyle(fontSize: 16)),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: max(16, size.height * 0.06)),
                child: const Text('Designed for phones — works in the browser',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EnvelopeWidget extends StatelessWidget {
  final AnimationController controller;
  const EnvelopeWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Envelope composed of a rectangle and a 'flap' that rotates when opening.
    return SizedBox(
      width: 180,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // envelope body
          Container(
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0,4))],
            ),
            child: const Center(child: Text('💌', style: TextStyle(fontSize: 40))),
          ),
          // flap
          Positioned(
            top: 10,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final angle = controller.value * -pi / 1.6; // rotate up
                return Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()..rotateX(angle),
                  child: child,
                );
              },
              child: Container(
                width: 170,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('❤️', style: TextStyle(fontSize: 24))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LetterScreen extends StatelessWidget {
  const LetterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // the letter card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('❤️', style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 8),
                    const Text('מכתב קטן בשבילך ❤️', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 18),
                    const Text('את אוהבת אותי?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 28),
                    // Buttons area — using a responsive width
                    SizedBox(
                      height: 64,
                      child: ButtonsArea(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('חזרה', style: TextStyle(color: Colors.black54)),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonsArea extends StatefulWidget {
  @override
  State<ButtonsArea> createState() => _ButtonsAreaState();
}

class _ButtonsAreaState extends State<ButtonsArea> {
  // Position (0..1) relative to container for evasive button
  double x = 0.15, y = 0.15; // initial relative position
  final Random rnd = Random();

  void _moveRandom(BoxConstraints c, Size btnSize) {
    final maxX = max(0.0, c.maxWidth - btnSize.width);
    final maxY = max(0.0, c.maxHeight - btnSize.height);
    final newX = rnd.nextDouble() * maxX;
    final newY = rnd.nextDouble() * maxY;
    setState(() {
      // store absolute pixels via state by converting relative
      x = newX / max(maxX, 1);
      y = newY / max(maxY, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // button sizes (approx)
      const btnW = 120.0;
      const btnH = 44.0;
      final left = (constraints.maxWidth - btnW) / 2 - 70; // left for Yes
      final right = (constraints.maxWidth - btnW) / 2 + 70; // start for No

      // compute evasive button absolute position
      final evasiveLeft = x * max(0.0, constraints.maxWidth - btnW);
      final evasiveTop = y * max(0.0, constraints.maxHeight - btnH);

      return Stack(
        clipBehavior: Clip.none,
        children: [
          // YES button centered bottom
          Positioned(
            left: (constraints.maxWidth - btnW) / 2 - 70,
            top: (constraints.maxHeight - btnH) / 2,
            child: SizedBox(
              width: btnW,
              height: btnH,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SuccessScreen()));
                },
                child: const Text('כן ❤️', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              ),
            ),
          ),
          // NO evasive button
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            left: evasiveLeft,
            top: evasiveTop,
            child: MouseRegion(
              onEnter: (_) => _moveRandom(constraints, const Size(btnW, btnH)),
              child: GestureDetector(
                onTapDown: (_) => _moveRandom(constraints, const Size(btnW, btnH)),
                // intentionally no onTap so it can't be pressed
                child: SizedBox(
                  width: btnW,
                  height: btnH,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                    child: const Text('לא 😈', style: TextStyle(color: Colors.black87)),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFEAF0), Color(0xFFFFCFE6)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 240,
                child: Stack(
                  children: List.generate(6, (i) => FloatingHeart(index: i, controller: _ctrl)),
                ),
              ),
              const SizedBox(height: 8),
              const Text('תודה! ❤️', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('ידעתי שתבחרי נכון 😏', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('עוד פעם ❤️'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingHeart extends StatelessWidget {
  final int index;
  final AnimationController controller;
  const FloatingHeart({Key? key, required this.index, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final start = (index / 6);
    final anim = CurvedAnimation(parent: controller, curve: Interval(start, start + 0.7, curve: Curves.easeOut));
    final random = Random(index);
    final left = random.nextDouble() * MediaQuery.of(context).size.width * 0.6;
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final dy = Tween(begin: 160.0, end: -40.0).evaluate(anim);
        final opacity = Tween(begin: 0.0, end: 1.0).evaluate(CurvedAnimation(parent: anim, curve: const Interval(0.0, 0.2))) * (1 - anim.value);
        return Positioned(
          left: left,
          top: dy,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Text('❤️', style: TextStyle(fontSize: 22 + (index % 3) * 6.0)),
          ),
        );
      },
    );
  }
}
