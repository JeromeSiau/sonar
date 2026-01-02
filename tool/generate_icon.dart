import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  print('Generating SONAR Neon icon...');

  const size = 1024;
  const center = size ~/ 2;

  const bgColor = 0xFF000000;
  const neonCyan = 0xFF00FFFF;

  final image = img.Image(width: size, height: size);
  img.fill(image, color: img.ColorRgba8(0x00, 0x00, 0x00, 0xFF));

  _drawGlow(image, center, center, (size * 0.5).toInt(), neonCyan, 0.15);
  _drawGlow(image, center, center, (size * 0.35).toInt(), neonCyan, 0.1);

  _drawCircle(
    image,
    center,
    center,
    (size * 0.40).toInt(),
    neonCyan,
    0.4,
    (size * 0.015).toInt(),
  );
  _drawCircle(
    image,
    center,
    center,
    (size * 0.28).toInt(),
    neonCyan,
    0.6,
    (size * 0.02).toInt(),
  );
  _drawCircle(
    image,
    center,
    center,
    (size * 0.16).toInt(),
    neonCyan,
    0.9,
    (size * 0.025).toInt(),
  );

  _drawGlow(image, center, center, (size * 0.12).toInt(), neonCyan, 0.4);
  _fillCircle(image, center, center, (size * 0.07).toInt(), neonCyan, 1.0);

  final iconFile = File('assets/icon/icon.png');
  iconFile.writeAsBytesSync(img.encodePng(image));
  print('✓ Icon saved to assets/icon/icon.png');

  print('Generating adaptive icon foreground...');
  final foreground = img.Image(width: size, height: size);
  img.fill(foreground, color: img.ColorRgba8(0, 0, 0, 0));

  final fgScale = 0.75;

  _drawCircle(
    foreground,
    center,
    center,
    (size * 0.40 * fgScale).toInt(),
    neonCyan,
    0.4,
    (size * 0.015 * fgScale).toInt(),
  );
  _drawCircle(
    foreground,
    center,
    center,
    (size * 0.28 * fgScale).toInt(),
    neonCyan,
    0.6,
    (size * 0.02 * fgScale).toInt(),
  );
  _drawCircle(
    foreground,
    center,
    center,
    (size * 0.16 * fgScale).toInt(),
    neonCyan,
    0.9,
    (size * 0.025 * fgScale).toInt(),
  );
  _fillCircle(
    foreground,
    center,
    center,
    (size * 0.07 * fgScale).toInt(),
    neonCyan,
    1.0,
  );

  final fgFile = File('assets/icon/icon-foreground.png');
  fgFile.writeAsBytesSync(img.encodePng(foreground));
  print('✓ Foreground saved to assets/icon/icon-foreground.png');

  print('Generating splash...');
  final splash = img.Image(width: 1152, height: 1152);
  final splashCenter = 576;
  final splashScale = 0.45;

  img.fill(splash, color: img.ColorRgba8(0, 0, 0, 0));

  _drawCircle(
    splash,
    splashCenter,
    splashCenter,
    (1152 * 0.40 * splashScale).toInt(),
    neonCyan,
    0.4,
    (1152 * 0.018 * splashScale).toInt(),
  );
  _drawCircle(
    splash,
    splashCenter,
    splashCenter,
    (1152 * 0.28 * splashScale).toInt(),
    neonCyan,
    0.6,
    (1152 * 0.02 * splashScale).toInt(),
  );
  _drawCircle(
    splash,
    splashCenter,
    splashCenter,
    (1152 * 0.16 * splashScale).toInt(),
    neonCyan,
    0.9,
    (1152 * 0.022 * splashScale).toInt(),
  );
  _fillCircle(
    splash,
    splashCenter,
    splashCenter,
    (1152 * 0.07 * splashScale).toInt(),
    neonCyan,
    1.0,
  );

  final splashFile = File('assets/icon/splash.png');
  splashFile.writeAsBytesSync(img.encodePng(splash));
  print('✓ Splash saved to assets/icon/splash.png');

  print('\nDone! Now run:');
  print('  dart run flutter_launcher_icons');
  print('  dart run flutter_native_splash:create');
}

void _drawGlow(
  img.Image image,
  int cx,
  int cy,
  int radius,
  int color,
  double maxOpacity,
) {
  final r = (color >> 16) & 0xFF;
  final g = (color >> 8) & 0xFF;
  final b = color & 0xFF;

  for (int y = cy - radius; y <= cy + radius; y++) {
    for (int x = cx - radius; x <= cx + radius; x++) {
      final dx = x - cx;
      final dy = y - cy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist <= radius &&
          x >= 0 &&
          x < image.width &&
          y >= 0 &&
          y < image.height) {
        final opacity = maxOpacity * (1 - dist / radius);
        final a = (opacity * 255).toInt();
        _blendPixel(image, x, y, r, g, b, a);
      }
    }
  }
}

void _drawCircle(
  img.Image image,
  int cx,
  int cy,
  int radius,
  int color,
  double opacity,
  int thickness,
) {
  final r = (color >> 16) & 0xFF;
  final g = (color >> 8) & 0xFF;
  final b = color & 0xFF;
  final a = (opacity * 255).toInt();

  for (int t = 0; t < thickness; t++) {
    final currentRadius = radius - thickness ~/ 2 + t;
    for (double angle = 0; angle < 2 * math.pi; angle += 0.001) {
      final x = cx + (currentRadius * math.cos(angle)).toInt();
      final y = cy + (currentRadius * math.sin(angle)).toInt();
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        _blendPixel(image, x, y, r, g, b, a);
      }
    }
  }
}

void _fillCircle(
  img.Image image,
  int cx,
  int cy,
  int radius,
  int color,
  double opacity,
) {
  final r = (color >> 16) & 0xFF;
  final g = (color >> 8) & 0xFF;
  final b = color & 0xFF;
  final a = (opacity * 255).toInt();

  for (int y = cy - radius; y <= cy + radius; y++) {
    for (int x = cx - radius; x <= cx + radius; x++) {
      final dx = x - cx;
      final dy = y - cy;
      if (dx * dx + dy * dy <= radius * radius) {
        if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
          _blendPixel(image, x, y, r, g, b, a);
        }
      }
    }
  }
}

void _blendPixel(img.Image image, int x, int y, int r, int g, int b, int a) {
  final pixel = image.getPixel(x, y);
  final bgR = pixel.r.toInt();
  final bgG = pixel.g.toInt();
  final bgB = pixel.b.toInt();
  final bgA = pixel.a.toInt();

  final alpha = a / 255.0;
  final invAlpha = 1 - alpha;

  final newR = (r * alpha + bgR * invAlpha).toInt().clamp(0, 255);
  final newG = (g * alpha + bgG * invAlpha).toInt().clamp(0, 255);
  final newB = (b * alpha + bgB * invAlpha).toInt().clamp(0, 255);
  final newA = (a + bgA * invAlpha).toInt().clamp(0, 255);

  image.setPixel(x, y, img.ColorRgba8(newR, newG, newB, newA));
}
