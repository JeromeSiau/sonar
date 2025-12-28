import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bluetooth_finder/core/theme/app_colors.dart';

class HeartButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;

  const HeartButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 24,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _particleAnimation;

  bool _showParticles = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_scaleController);

    _particleAnimation = CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Run scale animation
    _scaleController.forward(from: 0);

    // Show particles only when adding to favorites
    if (!widget.isFavorite) {
      setState(() => _showParticles = true);
      _particleController.forward(from: 0).then((_) {
        if (mounted) {
          setState(() => _showParticles = false);
        }
      });
    }

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.size + 16,
        height: widget.size + 16,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Particle burst effect
            if (_showParticles)
              AnimatedBuilder(
                animation: _particleAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size * 2.5, widget.size * 2.5),
                    painter: _ParticlePainter(
                      progress: _particleAnimation.value,
                      color: AppColors.favorite,
                    ),
                  );
                },
              ),

            // Glow effect when favorited
            if (widget.isFavorite)
              Container(
                width: widget.size + 12,
                height: widget.size + 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.favorite.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),

            // Heart icon
            ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  widget.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  key: ValueKey(widget.isFavorite),
                  color: widget.isFavorite
                      ? AppColors.favorite
                      : AppColors.favoriteInactive,
                  size: widget.size,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;

  static const int _particleCount = 8;

  _ParticlePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < _particleCount; i++) {
      final angle = (2 * math.pi / _particleCount) * i;
      final radius = maxRadius * progress;
      final particleSize = 4.0 * (1 - progress);
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }

    // Draw ring
    final ringPaint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * (1 - progress);

    canvas.drawCircle(center, maxRadius * progress * 0.8, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
