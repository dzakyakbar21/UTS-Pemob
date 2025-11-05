import 'dart:math';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _iconCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _typingCtrl;

  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<double> _rotate;
  late Animation<double> _glow;

  String displayedTitle = "";
  final String appTitle = "Tech Quiz";

  @override
  void initState() {
    super.initState();

    // ICON ANIMATION
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scale = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_iconCtrl);

    _opacity = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeIn))
        .animate(_iconCtrl);

    _rotate = Tween<double>(begin: -0.8, end: 0.0)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_iconCtrl);

    _glow = Tween<double>(begin: 0.0, end: 35.0)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_iconCtrl);

    // PULSE RING
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // TYPING TITLE
    _typingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _typingCtrl.addListener(() {
      final count = (appTitle.length * _typingCtrl.value).floor();
      setState(() {
        displayedTitle = appTitle.substring(0, count);
      });
    });

    // ---- ANTI-SKIP: Mulai animasi setelah UI dirender ----
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimationsSafely();
    });

    // ---- AVOID ANIMATION SKIP: Delay navigation lebih lama ----
    Future.delayed(const Duration(milliseconds: 4300), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, anim, __) =>
              FadeTransition(opacity: anim, child: const HomePage()),
        ),
      );
    });
  }

  // FORCE animation to always restart (solve Android random skip)
  void _startAnimationsSafely() {
    // Reset state
    _iconCtrl.reset();
    _pulseCtrl.reset();
    _typingCtrl.reset();

    // Start
    _iconCtrl.forward();
    _pulseCtrl.repeat();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _typingCtrl.forward();
    });
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _pulseCtrl.dispose();
    _typingCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          const _SlowAnimatedGradientBackground(),

          Positioned.fill(
            child: CustomPaint(
              painter: _RadialGlow(color: cs.primary.withOpacity(0.18)),
            ),
          ),

          const Positioned.fill(child: _FloatingParticles()),

          // PULSE RING
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) {
                return CustomPaint(
                  painter: _PulseRing(
                    progress: _pulseCtrl.value,
                    color: cs.primary.withOpacity(0.20),
                  ),
                );
              },
            ),
          ),

          // ICON
          Center(
            child: AnimatedBuilder(
              animation: _iconCtrl,
              builder: (_, __) {
                return Opacity(
                  opacity: _opacity.value,
                  child: Transform.rotate(
                    angle: _rotate.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primaryContainer,
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.45),
                              blurRadius: _glow.value,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.quiz,
                          size: 76,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // TYPING TITLE
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              displayedTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface.withOpacity(0.85),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================
// BACKGROUND: Slow rotating gradient
// =======================================
class _SlowAnimatedGradientBackground extends StatefulWidget {
  const _SlowAnimatedGradientBackground({super.key});

  @override
  State<_SlowAnimatedGradientBackground> createState() =>
      _SlowAnimatedGradientBackgroundState();
}

class _SlowAnimatedGradientBackgroundState
    extends State<_SlowAnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14), // slow & elegant
    )..repeat();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: GradientRotation(ctrl.value * pi * 2),
              colors: [
                cs.primary.withOpacity(0.30),
                cs.secondary.withOpacity(0.28),
                cs.surface,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}

// =======================================
// RADIAL GLOW
// =======================================
class _RadialGlow extends CustomPainter {
  final Color color;
  _RadialGlow({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..shader = RadialGradient(
        radius: 0.5,
        colors: [color, Colors.transparent],
      ).createShader(
        Rect.fromCircle(center: center, radius: size.shortestSide * 0.55),
      );
    canvas.drawCircle(center, size.shortestSide * 0.55, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// =======================================
// FLOATING PARTICLES
// =======================================
class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles({super.key});

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController ctrl;
  final Random r = Random();
  final int count = 32;
  late List<Offset> particles;

  @override
  void initState() {
    super.initState();
    particles = List.generate(count, (_) => Offset(r.nextDouble(), r.nextDouble()));

    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withOpacity(0.14);

    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        return CustomPaint(
          painter: _ParticlePainter(
            particles: particles,
            progress: ctrl.value,
            color: color,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Offset> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (var p in particles) {
      final dx =
          (p.dx + progress * 0.015) % 1.0;
      final dy =
          (p.dy + progress * 0.010) % 1.0;

      final pos = Offset(dx * size.width, dy * size.height);
      canvas.drawCircle(pos, 3, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

// =======================================
// PULSE RING
// =======================================
class _PulseRing extends CustomPainter {
  final double progress;
  final Color color;

  _PulseRing({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final radius = (progress * 0.9) * size.shortestSide * 0.5;
    final paint = Paint()
      ..color = color.withOpacity(1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * (1 - progress);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
