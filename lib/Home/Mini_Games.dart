// // ignore_for_file: deprecated_member_use
// import 'package:flutter/material.dart';

// const kPurple = Color(0xFF7B2FBE);

// class MiniGamesScreen extends StatelessWidget {
//   const MiniGamesScreen({super.key});

//   static const List<Map<String, String>> _games = [
//     {
//       'title': 'Mini Car Game',
//       'desc': 'Calm your mind and reduce stress. Calm your mind and reduce stress.',
//       'image': 'assets/MiniGames.png',
//     },
//     {
//       'title': 'Monkey Game',
//       'desc': 'Tired of overthinking ? Take a moment and reduce the noise inside your head.',
//       'image': 'assets/Mini_Games2.png',
//     },
//     {
//       'title': 'Spinner Game',
//       'desc': 'Nothing worth all of these bad feelings ,Time pass and everything will be fine just pause it and let it go with something else.',
//       'image': 'assets/Mini_Games3.jpeg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Mini Games',
//           style: TextStyle(
//             color: kPurple,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//       ),
//       body: ScrollConfiguration(
//         behavior: const ScrollBehavior().copyWith(overscroll: false),
//         child: ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: _games.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 16),
//           itemBuilder: (context, i) => _GameCard(
//             title: _games[i]['title']!,
//             description: _games[i]['desc']!,
//             image: _games[i]['image']!,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _GameCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String image;

//   const _GameCard({
//     required this.title,
//     required this.description,
//     required this.image,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Image.asset(
//               image,
//               height: 170,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => Container(
//                 height: 170,
//                 width: double.infinity,
//                 color: const Color(0xFF1A237E),
//                 child: const Icon(Icons.sports_esports,
//                     color: Colors.white54, size: 60),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
//             child: SizedBox(
//               width: double.infinity,
//               height: 46,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: kPurple,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'Play Now',
//                   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const kPurple = Color(0xFF7B2FBE);

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  static const List<Map<String, String>> _games = [
    {
      'title': 'Mini Car Game',
      'desc': 'Drive a calm racing track to lower stress and stay focused.',
      'image': 'assets/MiniGames.png',
    },
    {
      'title': 'Monkey Puzzle',
      'desc': 'Tired of overthinking ? Take a moment and reduce the noise inside your head.',
      'image': 'assets/Mini_Games2.png',
    },
    {
      'title': 'Calming Puzzle',
      'desc': 'Nothing worth all of these bad feelings ,Time pass and everything will be fine just pause it and let it go with something else.',
      'image': 'assets/Mini_Games3.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mini Games',
          style: TextStyle(
            color: kPurple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _games.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) => _GameCard(
            title: _games[i]['title']!,
            description: _games[i]['desc']!,
            image: _games[i]['image']!,
            onPressed: () {
              if (i == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarGameScreen()),
                );
              } else if (i == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MonkeyPuzzleScreen()),
                );
              } else if (i == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FidgetSpinnerScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_games[i]['title']} will be available soon!'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class CarGameScreen extends StatefulWidget {
  const CarGameScreen({super.key});

  @override
  State<CarGameScreen> createState() => _CarGameScreenState();
}

class MonkeyPuzzleScreen extends StatefulWidget {
  const MonkeyPuzzleScreen({super.key});

  @override
  State<MonkeyPuzzleScreen> createState() => _MonkeyPuzzleScreenState();
}

class FidgetSpinnerScreen extends StatefulWidget {
  const FidgetSpinnerScreen({super.key});

  @override
  State<FidgetSpinnerScreen> createState() => _FidgetSpinnerScreenState();
}

class _FidgetSpinnerScreenState extends State<FidgetSpinnerScreen> with SingleTickerProviderStateMixin {
  double _rotation = 0.0;
  double _angularVelocity = 0.0;
  double _spinPower = 0.0;
  double _maxSpinPower = 0.0;
  bool _isSpinning = false;
  bool _calmMode = false;
  Offset? _lastPosition;
  double? _lastAngle;
  int? _lastTime;
  Duration? _lastTick;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    final previousTick = _lastTick ?? elapsed;
    final dt = (elapsed - previousTick).inMicroseconds / 1e6;
    _lastTick = elapsed;

    if (_angularVelocity.abs() < 0.0002) {
      if (_isSpinning) {
        setState(() {
          _isSpinning = false;
          _angularVelocity = 0;
          _spinPower = 0;
        });
      }
      return;
    }

    setState(() {
      _rotation = (_rotation + _angularVelocity * dt) % (2 * pi);
      final friction = _calmMode ? 0.992 : 0.986;
      _angularVelocity *= pow(friction, dt * 60);
      _spinPower = (_angularVelocity.abs() * 60 / (2 * pi)).clamp(0, 320);
      _maxSpinPower = max(_maxSpinPower, _spinPower);
      if (_angularVelocity.abs() < 0.0002) {
        _angularVelocity = 0;
        _spinPower = 0;
        _isSpinning = false;
      }
    });
  }

  double _angleForPosition(RenderBox box, Offset position) {
    final center = box.size.center(Offset.zero);
    final relative = position - center;
    return atan2(relative.dy, relative.dx);
  }

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    _lastPosition = details.localPosition;
    _lastAngle = _angleForPosition(box, _lastPosition!);
    _lastTime = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _isSpinning = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final currentPosition = details.localPosition;
    final currentAngle = _angleForPosition(box, currentPosition);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (_lastAngle == null || _lastTime == null) {
      _lastAngle = currentAngle;
      _lastTime = currentTime;
      return;
    }

    var delta = currentAngle - _lastAngle!;
    if (delta > pi) {
      delta -= 2 * pi;
    } else if (delta < -pi) {
      delta += 2 * pi;
    }

    final dt = max(1, currentTime - _lastTime!) / 1000;
    final targetVelocity = delta / dt;
    final velocityBlend = 0.3;

    setState(() {
      _rotation = (_rotation + delta) % (2 * pi);
      _angularVelocity = _angularVelocity * (1 - velocityBlend) + targetVelocity * velocityBlend;
      _spinPower = (_angularVelocity.abs() * 60 / (2 * pi)).clamp(0, 320);
      _maxSpinPower = max(_maxSpinPower, _spinPower);
      _isSpinning = true;
    });

    _lastAngle = currentAngle;
    _lastTime = currentTime;
    _lastPosition = currentPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    _lastPosition = null;
    _lastAngle = null;
    _lastTime = null;
  }

  void _resetSpinner() {
    setState(() {
      _rotation = 0;
      _angularVelocity = 0;
      _spinPower = 0;
      _isSpinning = false;
      _lastPosition = null;
      _lastAngle = null;
      _lastTime = null;
      _lastTick = null;
    });
  }

  void _toggleCalmMode() {
    setState(() {
      _calmMode = !_calmMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayPower = _spinPower.round();
    final displayMax = _maxSpinPower.round();
    final spinnerColor = _calmMode ? const Color(0xFF5B3CDB) : const Color(0xFF7B2FBE);
    final accentColor = _calmMode ? const Color(0xFFB39DDB) : const Color(0xFFFFD95D);
    return Scaffold(
      backgroundColor: const Color(0xFFEFF0FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPurple),
        title: const Text('Fidget Spinner', style: TextStyle(color: kPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Relax with rhythm', style: TextStyle(color: kPurple, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Gently spin the fidget spinner clockwise or counterclockwise. Let the motion calm your mind while the spinner glides smoothly.',
                    style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _calmMode ? const Color(0xFFF4EEFF) : const Color(0xFFF3ECFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Spin strength', style: TextStyle(color: Colors.black54, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text('$displayPower RPM', style: const TextStyle(color: kPurple, fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Peak $displayMax RPM', style: const TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                        Icon(_calmMode ? Icons.self_improvement : Icons.spa, color: kPurple, size: 36),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _toggleCalmMode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _calmMode ? Colors.purple.shade100 : Colors.white,
                            foregroundColor: kPurple,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: Colors.purple.shade100),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(_calmMode ? 'Calm mode on' : 'Calm mode off'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _resetSpinner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kPurple,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: Colors.purple.shade100),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.white.withOpacity(0.24), Colors.transparent],
                            stops: const [0.3, 1],
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: _rotation,
                        child: CustomPaint(
                          size: const Size(280, 280),
                          painter: _FidgetSpinnerPainter(bodyColor: spinnerColor, accentColor: accentColor),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        child: AnimatedOpacity(
                          opacity: _isSpinning ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Text(
                              'Spinning smoothly... $displayPower RPM',
                              style: const TextStyle(color: kPurple, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Sweep around the spinner in a circular motion. A gentle spin encourages a calm rhythm.', style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _FidgetSpinnerPainter extends CustomPainter {
  const _FidgetSpinnerPainter({required this.bodyColor, required this.accentColor});

  final Color bodyColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final bodyPaint = Paint()..color = bodyColor;
    final accentPaint = Paint()..color = accentColor;
    final outlinePaint = Paint()..color = Colors.white.withOpacity(0.18);
    final Shader highlightShader = RadialGradient(
      colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.0)],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.5));
    final highlightPaint = Paint()..shader = highlightShader;

    final armRadius = size.width * 0.13;
    final armDistance = size.width * 0.19;

    final bodyPath = Path()..addOval(Rect.fromCircle(center: center, radius: size.width * 0.15));
    for (var i = 0; i < 3; i++) {
      final angle = i * 2 * pi / 3;
      final armCenter = center + Offset(cos(angle), sin(angle)) * armDistance;
      bodyPath.addOval(Rect.fromCircle(center: armCenter, radius: armRadius));
    }

    canvas.drawShadow(bodyPath, Colors.black.withOpacity(0.16), 10, false);
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, outlinePaint..style = PaintingStyle.stroke..strokeWidth = 4);

    for (var i = 0; i < 3; i++) {
      final angle = i * 2 * pi / 3;
      final armCenter = center + Offset(cos(angle), sin(angle)) * armDistance;
      canvas.drawCircle(armCenter, armRadius * 0.55, accentPaint);
      canvas.drawCircle(armCenter, armRadius * 0.28, Paint()..color = Colors.white.withOpacity(0.95));
    }

    final centerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.white.withOpacity(0.45);
    canvas.drawCircle(center, size.width * 0.14, centerRingPaint);
    canvas.drawCircle(center, size.width * 0.08, Paint()..color = Colors.white);
    canvas.drawCircle(center, size.width * 0.05, Paint()..color = bodyColor.withOpacity(0.95));
    canvas.drawCircle(center, size.width * 0.035, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PuzzleData {
  const _PuzzleData({required this.answer, required this.hint});

  final String answer;
  final String hint;
}

class _BankLetter {
  _BankLetter(this.letter);

  final String letter;
  bool used = false;
}

class _MonkeyPuzzleScreenState extends State<MonkeyPuzzleScreen> {
  static const List<_PuzzleData> _allPuzzles = [
    _PuzzleData(answer: 'CALM', hint: 'A peaceful state of mind and body'),
    _PuzzleData(answer: 'PEACE', hint: 'Tranquility and freedom from worry'),
    _PuzzleData(answer: 'SMILE', hint: 'A warm and joyful expression'),
    _PuzzleData(answer: 'BREATHE', hint: 'Take a slow, deep inhale and exhale'),
    _PuzzleData(answer: 'RELAX', hint: 'Release tension and find comfort'),
    _PuzzleData(answer: 'LOVE', hint: 'A gentle and caring feeling'),
    _PuzzleData(answer: 'JOY', hint: 'Pure happiness and delight'),
    _PuzzleData(answer: 'NATURE', hint: 'Trees, flowers, and the outdoor world'),
    _PuzzleData(answer: 'SLEEP', hint: 'Restful night of peaceful dreams'),
    _PuzzleData(answer: 'DREAM', hint: 'Imagination while you rest'),
    _PuzzleData(answer: 'MUSIC', hint: 'Soothing melodies that heal the soul'),
    _PuzzleData(answer: 'LIGHT', hint: 'Warm and gentle brightness'),
    _PuzzleData(answer: 'WARMTH', hint: 'A cozy, comfortable feeling'),
    _PuzzleData(answer: 'KINDNESS', hint: 'Compassion and gentle care for others'),
    _PuzzleData(answer: 'HOPE', hint: 'Belief in a better tomorrow'),
    _PuzzleData(answer: 'GRACE', hint: 'Elegant and gentle movement'),
    _PuzzleData(answer: 'SERENE', hint: 'Calm and peaceful like still water'),
    _PuzzleData(answer: 'BLOOM', hint: 'Flowers opening to the sun'),
    _PuzzleData(answer: 'SUNSET', hint: 'Beautiful evening sky over the horizon'),
    _PuzzleData(answer: 'MEADOW', hint: 'A field of soft, green grass'),
    _PuzzleData(answer: 'COMFORT', hint: 'A place of ease and safety'),
    _PuzzleData(answer: 'HARMONY', hint: 'Perfect balance and unity'),
    _PuzzleData(answer: 'GENTLE', hint: 'Soft, kind, and tender care'),
    _PuzzleData(answer: 'BEAUTY', hint: 'Visual loveliness and grace'),
    _PuzzleData(answer: 'FREEDOM', hint: 'Liberty and ability to be yourself'),
    _PuzzleData(answer: 'WISDOM', hint: 'Knowledge and understanding of life'),
    _PuzzleData(answer: 'HEALING', hint: 'Recovery and restoration of health'),
    _PuzzleData(answer: 'QUIET', hint: 'Peaceful silence and stillness'),
    _PuzzleData(answer: 'STARLIGHT', hint: 'Twinkling lights in the night sky'),
    _PuzzleData(answer: 'MINDFUL', hint: 'Present and aware in this moment'),
    _PuzzleData(answer: 'NURTURE', hint: 'Caring support and growth'),
    _PuzzleData(answer: 'SPIRIT', hint: 'Inner essence and soul'),
    _PuzzleData(answer: 'BALANCE', hint: 'Equilibrium of body and mind'),
    _PuzzleData(answer: 'PRESENT', hint: 'Being here and now with awareness'),
    _PuzzleData(answer: 'EMBRACE', hint: 'Hold close with warmth and love'),
  ];

  late List<_PuzzleData> _shuffledPuzzles;
  int _currentIndex = 0;
  late List<String> _filled;
  late List<_BankLetter> _bankLetters;
  bool _completed = false;
  int _hintsUsed = 0;

  @override
  void initState() {
    super.initState();
    _shuffledPuzzles = [..._allPuzzles];
    _shuffledPuzzles.shuffle();
    _preparePuzzle();
  }

  void _preparePuzzle() {
    final answer = _shuffledPuzzles[_currentIndex].answer;
    _filled = List.filled(answer.length, '');
    final letters = [...answer.split(''), 'A', 'R', 'L', 'X', 'P', 'U'];
    letters.shuffle();
    _bankLetters = letters.map((letter) => _BankLetter(letter)).toList();
    _completed = false;
    _hintsUsed = 0;
  }

  void _selectLetter(int index) {
    if (_completed || index >= _bankLetters.length || _bankLetters[index].used) return;
    final nextSlot = _filled.indexOf('');
    if (nextSlot == -1) return;

    setState(() {
      _bankLetters[index].used = true;
      _filled[nextSlot] = _bankLetters[index].letter;
      if (!_filled.contains('') && _filled.join() == _shuffledPuzzles[_currentIndex].answer) {
        _completed = true;
      }
    });
  }

  void _removeLetter(int index) {
    if (_completed || index >= _filled.length || _filled[index].isEmpty) return;
    final removed = _filled[index];
    _filled[index] = '';
    final bankIndex = _bankLetters.indexWhere((item) => item.letter == removed && item.used);
    if (bankIndex != -1) {
      setState(() {
        _bankLetters[bankIndex].used = false;
      });
    } else {
      setState(() {});
    }
  }

  void _nextPuzzle() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _shuffledPuzzles.length;
      _preparePuzzle();
    });
  }

  void _resetPuzzle() {
    setState(() {
      _preparePuzzle();
    });
  }

  void _giveHint() {
    if (_hintsUsed >= 3) return;
    
    final emptyIndices = _filled.asMap().entries.where((e) => e.value.isEmpty).map((e) => e.key).toList();
    if (emptyIndices.isEmpty) return;

    final randomIndex = emptyIndices[Random().nextInt(emptyIndices.length)];
    final hintLetter = _shuffledPuzzles[_currentIndex].answer[randomIndex];
    final bankIndex = _bankLetters.indexWhere((item) => item.letter == hintLetter && !item.used);

    if (bankIndex != -1) {
      setState(() {
        _hintsUsed++;
        _bankLetters[bankIndex].used = true;
        _filled[randomIndex] = hintLetter;
        if (!_filled.contains('') && _filled.join() == _shuffledPuzzles[_currentIndex].answer) {
          _completed = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = _shuffledPuzzles[_currentIndex];
    final answer = puzzle.answer;

    return Scaffold(
      backgroundColor: const Color(0xFFF7EFE1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPurple),
        title: const Text('Monkey Puzzle', style: TextStyle(color: kPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFFFF6E2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Gentle Puzzle', style: TextStyle(color: kPurple, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(puzzle.hint, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4)),
                          ],
                        ),
                      ),
                      const Text('🐵', style: TextStyle(fontSize: 42)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2E2B4),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.brown.shade200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Fill the letters to complete the word', style: TextStyle(color: Colors.brown, fontSize: 14)),
                        const SizedBox(height: 14),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(answer.length, (index) {
                              final letter = _filled[index];
                              final boxSize = answer.length > 8 ? 38.0 : (answer.length > 6 ? 42.0 : 46.0);
                              final fontSize = answer.length > 8 ? 18.0 : (answer.length > 6 ? 20.0 : 24.0);
                              return GestureDetector(
                                onTap: () => _removeLetter(index),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: boxSize,
                                  height: boxSize + 10,
                                  decoration: BoxDecoration(
                                    color: letter.isEmpty ? Colors.white : const Color(0xFF7B2FBE),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.brown.shade200),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      letter.isEmpty ? '' : letter,
                                      style: TextStyle(
                                        color: letter.isEmpty ? Colors.brown.shade700 : Colors.white,
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: !_completed && _hintsUsed < 3 ? _giveHint : null,
                                icon: const Icon(Icons.lightbulb_outline, size: 18),
                                label: Text('Hint (${3 - _hintsUsed})', style: const TextStyle(fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !_completed && _hintsUsed < 3 ? Colors.amber.shade400 : Colors.grey.shade300,
                                  foregroundColor: !_completed && _hintsUsed < 3 ? Colors.brown.shade800 : Colors.grey.shade600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: !_completed ? _nextPuzzle : null,
                                icon: const Icon(Icons.skip_next, size: 18),
                                label: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !_completed ? Colors.red.shade400 : Colors.grey.shade300,
                                  foregroundColor: !_completed ? Colors.white : Colors.grey.shade600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_completed)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B2FBE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text('Nice work! Tap Next to continue.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Letter bank', style: TextStyle(color: kPurple, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(_bankLetters.length, (index) {
                        final item = _bankLetters[index];
                        return GestureDetector(
                          onTap: item.used ? null : () => _selectLetter(index),
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: item.used ? Colors.white70 : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: item.used ? Colors.grey.shade300 : Colors.brown.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                item.letter,
                                style: TextStyle(
                                  color: item.used ? Colors.grey.shade500 : kPurple,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetPuzzle,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: kPurple,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              side: const BorderSide(color: kPurple),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _completed ? _nextPuzzle : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _completed ? kPurple : Colors.grey.shade300,
                              foregroundColor: _completed ? Colors.white : Colors.grey.shade600,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(_currentIndex + 1 < _shuffledPuzzles.length ? 'Next' : 'Finish', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Tap a letter to place it in the next empty box. Tap a filled box to remove it.', style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackObject {
  _TrackObject({required this.lane, required this.y, required this.isCoin, required this.color});

  int lane;
  double y;
  final bool isCoin;
  final Color color;
}

class _CarGameScreenState extends State<CarGameScreen> {
  static const lanePositions = [-0.55, 0.0, 0.55];
  int _lane = 1;
  int _coins = 0;
  int _score = 0;
  double _speed = 0.025;
  bool _isGameOver = false;
  bool _isFlying = false;
  double _flyRemaining = 0.0;
  double _flyCooldown = 0.0;
  Timer? _timer;
  final List<_TrackObject> _objects = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _timer?.cancel();
    _lane = 1;
    _coins = 0;
    _score = 0;
    _speed = 0.025;
    _isGameOver = false;
    _isFlying = false;
    _flyRemaining = 0.0;
    _flyCooldown = 0.0;
    _objects.clear();

    for (var i = 0; i < 5; i++) {
      _objects.add(_createRandomObject(startOffset: -0.8 - i * 0.55));
    }

    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!mounted) return;
      setState(() {
        _speed = min(0.06, _speed + 0.00005);
        for (final object in _objects) {
          object.y += _speed;
        }

        if (_flyRemaining > 0) {
          _flyRemaining = max(0, _flyRemaining - 0.04);
          if (_flyRemaining <= 0) {
            _isFlying = false;
          }
        }
        if (_flyCooldown > 0) {
          _flyCooldown = max(0, _flyCooldown - 0.04);
        }

        for (final object in List<_TrackObject>.from(_objects)) {
          if (object.y > 1.25) {
            if (!object.isCoin) {
              _score += 1;
            }
            _objects.remove(object);
            _objects.add(_createRandomObject());
          }
        }

        for (final object in _objects) {
          if (!object.isCoin && !_isFlying && object.lane == _lane && object.y > 0.72 && object.y < 0.96) {
            _isGameOver = true;
            _timer?.cancel();
          }
          if (object.isCoin && object.lane == _lane && object.y > 0.72 && object.y < 0.96) {
            _coins += 1;
            _objects.remove(object);
            _objects.add(_createRandomObject());
            break;
          }
        }
      });
    });
  }

  _TrackObject _createRandomObject({double startOffset = -1.2}) {
    bool isCoin = Random().nextDouble() < 0.24;
    final availableLanes = List<int>.generate(3, (index) => index);
    final nearbyEnemyLanes = _objects
        .where((other) => !other.isCoin && (other.y - startOffset).abs() < 0.6)
        .map((other) => other.lane)
        .toSet();

    if (!isCoin && nearbyEnemyLanes.length >= 2) {
      isCoin = true;
    }

    final blockedLanes = _objects
        .where((other) => !other.isCoin && (other.y - startOffset).abs() < 0.5)
        .map((other) => other.lane)
        .toSet();
    final lanes = availableLanes.where((lane) => !blockedLanes.contains(lane)).toList();
    final lane = lanes.isEmpty ? Random().nextInt(3) : lanes[Random().nextInt(lanes.length)];
    final color = isCoin ? Colors.amber.shade700 : const Color(0xFFEB5757);
    return _TrackObject(lane: lane, y: startOffset, isCoin: isCoin, color: color);
  }

  void _moveLeft() {
    if (_isGameOver) return;
    setState(() {
      if (_lane > 0) _lane -= 1;
    });
  }

  void _moveRight() {
    if (_isGameOver) return;
    setState(() {
      if (_lane < 2) _lane += 1;
    });
  }

  void _handleTap(TapDownDetails details, BoxConstraints constraints) {
    if (_isGameOver) return;
    final center = constraints.maxWidth / 2;
    if (details.localPosition.dx < center) {
      _moveLeft();
    } else {
      _moveRight();
    }
  }

  void _activatePowerUp() {
    if (_isGameOver || _isFlying || _flyCooldown > 0) return;
    setState(() {
      _isFlying = true;
      _flyRemaining = 2.4;
      _flyCooldown = 8.6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPurple),
        title: const Text('Mini Car Game', style: TextStyle(color: kPurple, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat('Score', '$_score'),
                  _buildStat('Coins', '$_coins', icon: Icons.monetization_on, iconColor: Colors.amber),
                  _buildStat('Speed', '${(_speed * 100).round()}%'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) => _handleTap(details, constraints),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF3745A0), Color(0xFF1B2569)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _RoadPainter(),
                            ),
                          ),
                          ..._objects.map((object) {
                            return Align(
                              alignment: Alignment(lanePositions[object.lane], object.y),
                              child: object.isCoin ? _buildCoin() : _buildEnemyCar(object.color),
                            );
                          }),
                          Align(
                            alignment: Alignment(lanePositions[_lane], _isFlying ? 0.7 : 0.9),
                            child: _buildPlayerCar(flying: _isFlying),
                          ),
                          if (_isGameOver)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.54), borderRadius: BorderRadius.circular(28)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Crash!', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 14),
                                        const Text('A smooth drive is calming. Tap Play Again to restart and relax.', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: _startGame,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPurple,
                                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                          ),
                                          child: const Text('Play Again', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _moveLeft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4F4FF),
                        foregroundColor: kPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Icon(Icons.arrow_left, size: 32),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (!_isGameOver && !_isFlying && _flyCooldown <= 0) ? _activatePowerUp : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFlying || _flyCooldown > 0 ? Colors.grey.shade300 : const Color(0xFF7B2FBE),
                        foregroundColor: _isFlying || _flyCooldown > 0 ? Colors.grey.shade600 : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        _isFlying ? 'Flying' : (_flyCooldown > 0 ? 'Ready ${_flyCooldown.ceil()}s' : 'Fly'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _moveRight,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4F4FF),
                        foregroundColor: kPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Icon(Icons.arrow_right, size: 32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Tap on either side of the road to switch lanes, collect coins, and relax as you drive.', style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String value, {IconData? icon, Color? iconColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 6),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: iconColor ?? kPurple),
              const SizedBox(width: 6),
            ],
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildCoin() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.amber.shade700,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.monetization_on, color: Colors.white, size: 26),
      ),
    );
  }

  Widget _buildEnemyCar(Color color) {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 10,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.directions_car, color: Colors.white, size: 34),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
              Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCar({required bool flying}) {
    return Container(
      width: 92,
      height: 122,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.26),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (flying) ...[
            const Icon(Icons.flight_takeoff, color: kPurple, size: 24),
            const SizedBox(height: 4),
          ],
          const Icon(Icons.directions_car, color: kPurple, size: 46),
          const SizedBox(height: 10),
          Text(flying ? 'FLYING' : 'YOU', style: const TextStyle(color: kPurple, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF25316E);
    final track = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(RRect.fromRectAndRadius(track, const Radius.circular(28)), paint);

    final sidePaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width * 0.12, 0), Offset(size.width * 0.12, size.height), sidePaint);
    canvas.drawLine(Offset(size.width * 0.88, 0), Offset(size.width * 0.88, size.height), sidePaint);

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final dashHeight = 24.0;
    final gapHeight = 18.0;
    double y = 20;

    while (y < size.height - 20) {
      canvas.drawLine(
        Offset(size.width * 0.5, y),
        Offset(size.width * 0.5, y + dashHeight),
        linePaint,
      );
      y += dashHeight + gapHeight;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onPressed;

  const _GameCard({
    required this.title,
    required this.description,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 170,
                width: double.infinity,
                color: const Color(0xFF1A237E),
                child: const Icon(Icons.sports_esports,
                    color: Colors.white54, size: 60),
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Play Now button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Play Now',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}