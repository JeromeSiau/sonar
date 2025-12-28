import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  print('Generating SONAR icon (light background)...');

  const size = 1024;
  const center = size ~/ 2;

  // Create image with light mint background
  final image = img.Image(width: size, height: size);

  // Colors - bold and vibrant
  const bgColor = 0xFFFFFFFF;    // Pure white background
  const primary = 0xFF00A896;    // Vibrant teal
  const primaryDark = 0xFF007A6E; // Darker teal for depth

  // Fill with white background
  img.fill(image, color: img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF));

  // Draw concentric circles - BOLD
  final scale = 0.62;
  final scaledCenter = center;

  // Outer ring - visible
  _drawCircle(image, scaledCenter, scaledCenter, (size * 0.42 * scale).toInt(), primary, 0.5, (size * 0.035 * scale).toInt());

  // Middle ring - more visible
  _drawCircle(image, scaledCenter, scaledCenter, (size * 0.28 * scale).toInt(), primary, 0.75, (size * 0.038 * scale).toInt());

  // Inner ring - strong
  _drawCircle(image, scaledCenter, scaledCenter, (size * 0.15 * scale).toInt(), primaryDark, 1.0, (size * 0.042 * scale).toInt());

  // Center filled circle - bold
  _fillCircle(image, scaledCenter, scaledCenter, (size * 0.095 * scale).toInt(), primaryDark, 1.0);

  // Inner white dot
  _fillCircle(image, scaledCenter, scaledCenter, (size * 0.035 * scale).toInt(), bgColor, 1.0);

  // Save icon
  final iconFile = File('assets/icon/icon.png');
  iconFile.writeAsBytesSync(img.encodePng(image));
  print('✓ Icon saved to assets/icon/icon.png');

  // Generate FOREGROUND for adaptive icons (transparent background)
  // Android adaptive icons: 108dp canvas, 66dp safe zone = 61% scale
  // Content must stay within safe zone to avoid being clipped by mask
  print('Generating adaptive icon foreground...');
  final foreground = img.Image(width: size, height: size);
  img.fill(foreground, color: img.ColorRgba8(0, 0, 0, 0)); // Transparent

  // Fill 75-80% of the icon
  final fgScale = 0.78;

  // Outer ring - fills most of the safe zone
  _drawCircle(foreground, center, center, (size * 0.42 * fgScale).toInt(), primary, 0.55, (size * 0.035 * fgScale).toInt());

  // Middle ring
  _drawCircle(foreground, center, center, (size * 0.28 * fgScale).toInt(), primary, 0.75, (size * 0.038 * fgScale).toInt());

  // Inner ring
  _drawCircle(foreground, center, center, (size * 0.15 * fgScale).toInt(), primaryDark, 1.0, (size * 0.045 * fgScale).toInt());

  // Center filled circle
  _fillCircle(foreground, center, center, (size * 0.095 * fgScale).toInt(), primaryDark, 1.0);

  // Inner white dot
  _fillCircle(foreground, center, center, (size * 0.035 * fgScale).toInt(), 0xFFFFFFFF, 1.0);

  final fgFile = File('assets/icon/icon-foreground.png');
  fgFile.writeAsBytesSync(img.encodePng(foreground));
  print('✓ Foreground saved to assets/icon/icon-foreground.png');

  // Generate splash (transparent background)
  print('Generating splash...');
  final splash = img.Image(width: 1152, height: 1152);
  final splashCenter = 576;
  final splashScale = 0.45;
  const splashPrimary = 0xFF5ECFCF;

  // Transparent background
  img.fill(splash, color: img.ColorRgba8(0, 0, 0, 0));

  // Draw rings
  _drawCircle(splash, splashCenter, splashCenter, (1152 * 0.42 * splashScale).toInt(), splashPrimary, 0.35, (1152 * 0.022 * splashScale).toInt());
  _drawCircle(splash, splashCenter, splashCenter, (1152 * 0.29 * splashScale).toInt(), splashPrimary, 0.55, (1152 * 0.022 * splashScale).toInt());
  _drawCircle(splash, splashCenter, splashCenter, (1152 * 0.16 * splashScale).toInt(), splashPrimary, 0.85, (1152 * 0.025 * splashScale).toInt());

  // Center dot
  _fillCircle(splash, splashCenter, splashCenter, (1152 * 0.07 * splashScale).toInt(), splashPrimary, 1.0);

  final splashFile = File('assets/icon/splash.png');
  splashFile.writeAsBytesSync(img.encodePng(splash));
  print('✓ Splash saved to assets/icon/splash.png');

  print('\nDone! Now run:');
  print('  dart run flutter_launcher_icons');
  print('  dart run flutter_native_splash:create');
}

void _drawCircle(img.Image image, int cx, int cy, int radius, int color, double opacity, int thickness) {
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

void _fillCircle(img.Image image, int cx, int cy, int radius, int color, double opacity) {
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
