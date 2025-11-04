import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = Tween<double>(begin: 0.6, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_c);
    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_c);
    _rotation = Tween<double>(begin: -0.12, end: 0.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_c);

    _c.forward();
    _c.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 350));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // latar mengikuti tema (tanpa gambar), simple dan elegan
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          // aksen radial halus biar lebih “hidup” tapi tetap simple
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _SubtleRadialPainter(color: cs.primary.withOpacity(0.08)),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _c,
              builder: (_, __) {
                return Opacity(
                  opacity: _opacity.value,
                  child: Transform.rotate(
                    angle: _rotation.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.25),
                              blurRadius: 24,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.quiz,
                          size: 64,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // nama aplikasi kecil di bawah (fade masuk bareng)
          Positioned(
            bottom: 48,
            left: 0, right: 0,
            child: Opacity(
              opacity: _opacity.value,
              child: Text(
                'Tech Quiz',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtleRadialPainter extends CustomPainter {
  final Color color;
  _SubtleRadialPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.6;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _SubtleRadialPainter oldDelegate) =>
      oldDelegate.color != color;
}
