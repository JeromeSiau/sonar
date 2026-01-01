import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Service to play locator sound through connected Bluetooth audio devices.
///
/// Note: This only works when headphones/earbuds are CONNECTED to the phone
/// (not just visible via BLE scan). The system automatically routes audio
/// to connected Bluetooth audio devices.
class LocatorSoundService {
  AudioPlayer? _player;
  bool _isPlaying = false;
  Timer? _stopTimer;

  bool get isPlaying => _isPlaying;

  /// Plays a repeating beep sound for the specified duration.
  /// Sound is automatically routed to connected Bluetooth audio device.
  Future<void> playLocatorSound({Duration duration = const Duration(seconds: 10)}) async {
    if (_isPlaying) return;

    try {
      _player = AudioPlayer();
      _isPlaying = true;

      // Use a beep sound asset (5 beeps at 880Hz)
      await _player!.setAsset('assets/sounds/locator_beep.wav');

      // Set to loop
      await _player!.setLoopMode(LoopMode.all);

      // Max volume for locating
      await _player!.setVolume(1.0);

      // Start playing
      await _player!.play();

      // Auto-stop after duration
      _stopTimer?.cancel();
      _stopTimer = Timer(duration, () {
        stop();
      });
    } catch (e) {
      _isPlaying = false;
      rethrow;
    }
  }

  /// Stops the locator sound.
  Future<void> stop() async {
    _stopTimer?.cancel();
    _stopTimer = null;
    _isPlaying = false;

    if (_player != null) {
      await _player!.stop();
      await _player!.dispose();
      _player = null;
    }
  }

  /// Disposes the service.
  void dispose() {
    stop();
  }
}

/// Provider for the locator sound service.
final locatorSoundServiceProvider = Provider<LocatorSoundService>((ref) {
  final service = LocatorSoundService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for tracking if sound is currently playing.
final isPlayingSoundProvider = StateProvider<bool>((ref) => false);
