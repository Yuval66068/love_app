import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const LoveApp());
}

class LoveApp extends StatelessWidget {
  const LoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '❤️',
      theme: ThemeData(
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const LoveHomePage(),
    );
  }
}

class LoveHomePage extends StatefulWidget {
  const LoveHomePage({super.key});

  @override
  State<LoveHomePage> createState() => _LoveHomePageState();
}

class _LoveHomePageState extends State<LoveHomePage>
    with TickerProviderStateMixin {
  bool letterOpened = false;
  bool answered = false;

  double noX = 0;
  double noY = 0;

  final Random random = Random();

  late AnimationController envelopeController;
  late AnimationController heartController;

  @override
  void initState() {
    super.initState();

    envelopeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    envelopeController.dispose();
    heartController.dispose();
    super.dispose();
  }

  void openLetter() {
    setState(() {
      letterOpened = true;
    });

    envelopeController.forward();
  }

  void moveNoButton() {
    final size = MediaQuery.of(context).size;

    setState(() {
      noX = (random.nextDouble() * 2 - 1) * size.width * 0.28;
      noY = (random.nextDouble() * 2 - 1) * size.height * 0.18;
    });
  }

  void answerYes() {
    setState(() {
      answered = true;
    });
  }

  void restart() {
    setState(() {
      letterOpened = false;
      answered = false;
      noX = 0;
      noY = 0;
    });

    envelopeController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffffe6ef),
              Color(0xffffc1d9),
              Color(0xffffe9f2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: answered
                  ? buildSuccessScreen()
                  : letterOpened
                      ? buildQuestionScreen()
                      : buildEnvelopeScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEnvelopeScreen() {
    return GestureDetector(
      key: const ValueKey('envelope'),
      onTap: openLetter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'יש לי משהו לשאול אותך...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff7a2448),
            ),
          ),
          const SizedBox(height: 40),

          AnimatedBuilder(
            animation: envelopeController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 + envelopeController.value * 0.08,
                child: child,
              );
            },
            child: Container(
              width: 280,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xfffff5f8),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(280, 190),
                    painter: EnvelopePainter(),
                  ),
                  const Text(
                    '❤️',
                    style: TextStyle(fontSize: 65),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'לחצי על המכתב 💌',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff8d3158),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionScreen() {
    return Padding(
      key: const ValueKey('question'),
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '💌',
            style: TextStyle(fontSize: 55),
          ),

          const SizedBox(height: 15),

          Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'מכתב קטן בשבילך ❤️',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffa3446a),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'את אוהבת אותי?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff762443),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          SizedBox(
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: answerYes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe83e73),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'כן ❤️',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  left: MediaQuery.of(context).size.width / 2 - 20 + noX,
                  top: 5 + noY,
                  child: MouseRegion(
                    onEnter: (_) => moveNoButton(),
                    child: GestureDetector(
                      onTap: moveNoButton,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: const Color(0xffe83e73),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          'לא 😈',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xffe83e73),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 35),

          const Text(
            'רק תשובה אחת מתקבלת 😏',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff91415f),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuccessScreen() {
    return Stack(
      key: const ValueKey('success'),
      children: [
        ...List.generate(
          25,
          (index) => AnimatedBuilder(
            animation: heartController,
            builder: (context, child) {
              final progress =
                  (heartController.value + index / 25) % 1;

              return Positioned(
                left: (index * 47) % MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.height * progress,
                child: Opacity(
                  opacity: 1 - progress,
                  child: Text(
                    index % 2 == 0 ? '❤️' : '💕',
                    style: TextStyle(
                      fontSize: 20 + (index % 3) * 10,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🥰',
                  style: TextStyle(fontSize: 90),
                ),

                const SizedBox(height: 20),

                const Text(
                  'תודה! ❤️',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff762443),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'ידעתי שתבחרי נכון 😏',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff91415f),
                  ),
                ),

                const SizedBox(height: 50),

                ElevatedButton(
                  onPressed: restart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe83e73),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'עוד פעם ❤️',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffffc4d7)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height / 0.95);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}