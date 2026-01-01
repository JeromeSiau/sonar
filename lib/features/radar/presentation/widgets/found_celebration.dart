import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';
import 'package:bluetooth_finder/l10n/app_localizations.dart';

class FoundCelebration extends StatefulWidget {
  final VoidCallback onComplete;
  final AppLocalizations l10n;

  const FoundCelebration({super.key, required this.onComplete, required this.l10n});

  @override
  State<FoundCelebration> createState() => _FoundCelebrationState();
}

class _FoundCelebrationState extends State<FoundCelebration>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  final List<_Confetti> _confettiPieces = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Circle scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 15.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutExpo),
    );

    // Checkmark draw animation
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeOutBack),
    );

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Generate confetti pieces
    _generateConfetti();

    // Start animation sequence
    _startAnimations();
  }

  void _generateConfetti() {
    final colors = [
      AppColors.signalStrong,
      AppColors.signalMedium,
      Colors.white,
      const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D),
      const Color(0xFFFF6B6B),
    ];

    for (int i = 0; i < 50; i++) {
      _confettiPieces.add(_Confetti(
        color: colors[_random.nextInt(colors.length)],
        startX: _random.nextDouble(),
        startY: 0.3 + _random.nextDouble() * 0.4,
        velocityX: (_random.nextDouble() - 0.5) * 2,
        velocityY: -_random.nextDouble() * 1.5 - 0.5,
        rotation: _random.nextDouble() * math.pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        size: 8 + _random.nextDouble() * 8,
      ));
    }
  }

  void _startAnimations() async {
    // Scale up the circle
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 200));

    // Show checkmark
    _checkController.forward();

    // Start confetti
    _confettiController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));

    // Complete - check if still mounted before calling
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Expanding circle background
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: 120 * _scaleAnimation.value,
                  height: 120 * _scaleAnimation.value,
                  decoration: BoxDecoration(
                    color: AppColors.signalStrong,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),

          // Confetti
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ConfettiPainter(
                  confetti: _confettiPieces,
                  progress: _confettiController.value,
                ),
              );
            },
          ),

          // Checkmark
          Center(
            child: AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _checkAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: _CheckmarkPainter(
                        progress: _checkAnimation.value,
                        color: AppColors.signalStrong,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Success text
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _checkAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _checkAnimation.value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _checkAnimation.value)),
                    child: Text(
                      widget.l10n.found,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Confetti {
  final Color color;
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
  final double size;

  _Confetti({
    required this.color,
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Confetti> confetti;
  final double progress;

  _ConfettiPainter({required this.confetti, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in confetti) {
      final t = progress;
      final gravity = 2.0;

      final x = size.width * piece.startX + piece.velocityX * t * 200;
      final y = size.height * piece.startY +
          piece.velocityY * t * 200 +
          gravity * t * t * 300;

      final opacity = (1 - t).clamp(0.0, 1.0);
      final rotation = piece.rotation + piece.rotationSpeed * t;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = piece.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // Draw rectangle confetti
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: piece.size,
          height: piece.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // Checkmark points
    final start = Offset(center.dx - 18, center.dy);
    final middle = Offset(center.dx - 5, center.dy + 14);
    final end = Offset(center.dx + 20, center.dy - 12);

    path.moveTo(start.dx, start.dy);

    if (progress < 0.5) {
      // First half: draw first part of checkmark
      final t = progress * 2;
      final point = Offset.lerp(start, middle, t)!;
      path.lineTo(point.dx, point.dy);
    } else {
      // Second half: complete checkmark
      path.lineTo(middle.dx, middle.dy);
      final t = (progress - 0.5) * 2;
      final point = Offset.lerp(middle, end, t)!;
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
