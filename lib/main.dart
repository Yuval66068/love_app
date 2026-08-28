import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love App',
      debugShowCheckedModeBanner: false,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: LoveHomePage(),
      ),
    );
  }
}

class LoveHomePage extends StatefulWidget {
  const LoveHomePage({super.key});

  @override
  State<LoveHomePage> createState() => _LoveHomePageState();
}

class _LoveHomePageState extends State<LoveHomePage>
    with SingleTickerProviderStateMixin {
  // Position of the "לא" button in pixels relative to the area (left, top)
  late Offset _noPos;
  bool _accepted = false;
  late AnimationController _heartController;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _noPos = const Offset(220, 20); // initial
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _moveNoButton(Size areaSize, Size buttonSize) {
    // Make sure new position stays within area bounds
    final maxX = max(0.0, areaSize.width - buttonSize.width);
    final maxY = max(0.0, areaSize.height - buttonSize.height);
    // Try random positions until one is sufficiently far from the yes button
    Offset candidate;
    int tries = 0;
    do {
      final dx = _rnd.nextDouble() * maxX;
      final dy = _rnd.nextDouble() * maxY;
      candidate = Offset(dx, dy);
      tries++;
      if (tries > 50) break;
    } while ((candidate - _noPos).distance < 60);

    setState(() {
      _noPos = candidate;
    });
  }

  void _maybeAvoid(Offset pointerLocal, Size areaSize, Size buttonSize) {
    final noCenter = _noPos + Offset(buttonSize.width / 2, buttonSize.height / 2);
    if ((pointerLocal - noCenter).distance < 80) {
      _moveNoButton(areaSize, buttonSize);
    }
  }

  void _onYes() {
    if (_accepted) return;
    setState(() {
      _accepted = true;
    });
    _heartController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF1F5), Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, size: 72, color: Colors.pink),
                    const SizedBox(height: 12),
                    Text(
                      'את אוהבת אותי?',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Area where buttons live and the "לא" button will run away
                    LayoutBuilder(builder: (context, constraints) {
                      final areaSize = Size(constraints.maxWidth, 140);
                      final buttonSize = const Size(120, 48);
                      // Ensure _noPos initialized within bounds
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_noPos.dx + buttonSize.width > areaSize.width ||
                            _noPos.dy + buttonSize.height > areaSize.height) {
                          setState(() {
                            _noPos = Offset(
                              (areaSize.width - buttonSize.width) / 2,
                              20,
                            );
                          });
                        }
                      });

                      return MouseRegion(
                        onHover: (ev) {
                          final local = ev.localPosition;
                          _maybeAvoid(local, areaSize, buttonSize);
                        },
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanDown: (ev) {
                            final local = ev.localPosition;
                            _maybeAvoid(local, areaSize, buttonSize);
                          },
                          child: SizedBox(
                            width: areaSize.width,
                            height: areaSize.height,
                            child: Stack(
                              children: [
                                // Yes button - fixed position (left)
                                Positioned(
                                  left: 20,
                                  top: (areaSize.height - buttonSize.height) / 2,
                                  child: ElevatedButton(
                                    onPressed: _onYes,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: buttonSize,
                                      backgroundColor: Colors.pink,
                                    ),
                                    child: const Text('כן'),
                                  ),
                                ),

                                // No button - moving and never clickable
                                Positioned(
                                  left: _noPos.dx,
                                  top: _noPos.dy,
                                  child: AbsorbPointer(
                                    // AbsorbPointer prevents clicks
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.forbidden,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: buttonSize,
                                          backgroundColor: Colors.grey.shade300,
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text('לא'),
                                      ),
                                    ),
                                  ),
                                ),

                                // Animated hearts overlay when accepted
                                if (_accepted)
                                  ...List.generate(6, (i) {
                                    final startX = 60.0 + i * 20.0;
                                    return AnimatedBuilder(
                                      animation: _heartController,
                                      builder: (context, child) {
                                        final t = Curves.easeOut.transform(
                                            (_heartController.value - i * 0.08)
                                                .clamp(0.0, 1.0));
                                        final dy = 80 * t;
                                        final opacity = (1.0 - t).clamp(0.0, 1.0);
                                        return Positioned(
                                          left: startX,
                                          top: (areaSize.height / 2) - dy,
                                          child: Opacity(
                                            opacity: opacity,
                                            child: Icon(
                                              Icons.favorite,
                                              color: Color.fromRGBO(233, 30, 99, 0.9),
                                              size: 28 + 6 * (1 - t),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    if (_accepted)
                      Column(
                        children: const [
                          Text(
                            'ידעתי שתבחרי כן ❤️',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
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
