import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';
import 'package:sikshana/app/data/config/logger.dart';

import 'package:sikshana/app/ui/components/app_snackbar.dart';
import 'package:sikshana/app/utils/dialog_manager.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Enhanced Speech to text repository with continuous listening
class SpeechToTextRepo {
  /// Speech to text instance
  static stt.SpeechToText speech = stt.SpeechToText();

  /// Is listening
  static RxBool isListening = false.obs;

  /// Check if speech recognition is initialized
  static bool _isInitialized = false;

  /// Current speech callback
  static void Function(String)? _currentCallback;

  /// Get microphone permission and start listening continuously
  static Future<void> start({required void Function(String) onSpeech}) async {
    if (!_isInitialized) {
      final bool hadPermission = await speech.hasPermission;
      _isInitialized = await _initializeSpeech();

      if (!_isInitialized) {
        // Initialization failed, probably due to permission denial or device incompatibility.
        await stop();
        // Only show the permission dialog if they didn't have permission before.
        // This avoids showing it if initialization failed for other reasons.
        if (!hadPermission) {
          await _handlePermissionError();
        }
        return;
      }

      if (!hadPermission) {
        // Permission was just granted. This likely interrupted the long-press gesture,
        // so onLongPressEnd will not be called. To avoid getting stuck in a listening
        // state, we'll just stop here. The user can press and hold again to start listening.
        await stop();
        return;
      }
    }

    // If we reach here, we're initialized and have permission.
    _currentCallback = onSpeech;
    isListening(true);
    final String langCode = Get.locale?.languageCode ?? 'en';
    final String speechLocale = _localeToSpeechLocale(langCode);

    // Map to speech locale

    logD('App lang: $langCode → Speech locale: $speechLocale');
    try {
      await speech.listen(
        localeId: speechLocale,
        // localeId: 'kn-IN',
        onResult: (SpeechRecognitionResult result) {
          // logD(
          //   'Speech result: ${result.recognizedWords}, confidence: ${result.confidence}, final: ${result.finalResult}',
          // );

          // // Send all results (both partial and final) to callback
          // if (result.recognizedWords.isNotEmpty) {
          //   _currentCallback?.call(result.recognizedWords);
          // }
          logD(
            'SpeechRecognitionResult Speech result: ${result.recognizedWords}, : ${result.finalResult} _currentCallback${_currentCallback}',
          );
          if (result.recognizedWords.isEmpty) return;

          // Keep latest hypothesis
          String text = result.recognizedWords;

          if (result.finalResult) {
            logD(
              'SpeechRecognitionResultfinalResult  Speech result: ${result.recognizedWords}, final: ${_currentCallback}',
            );
            _currentCallback?.call(text);
            isListening(false);
            isListening.refresh();
            _currentCallback = null;
          }
        },
        listenOptions: stt.SpeechListenOptions(
          // Enable partial results for real-time feedback
          partialResults: true,
          // Don't cancel on errors - keep listening
          cancelOnError: true,
          // Disable haptic feedback
          enableHapticFeedback: false,
        ),
        // Set to maximum possible duration (no automatic timeout)
        // Most platforms support up to ~1 hour
        listenFor: Platform.isAndroid
            ? const Duration(minutes: 1) // shorter so finalResult fires sooner
            : const Duration(minutes: 1),
        pauseFor: Platform.isAndroid
            ? const Duration(seconds: 3) // typical end-of-utterance pause
            : const Duration(seconds: 3),
      );

      // Double-check if listening started successfully
      if (!speech.isListening) {
        await stop();
        appSnackBar(
          message: 'Voice search failed to start',
          state: SnackBarState.warning,
        );
      }
    } catch (e) {
      logE('Error starting speech recognition: $e');
      await stop();
      appSnackBar(
        message: 'Voice search unavailable',
        state: SnackBarState.warning,
      );
    }
  }

  static String _localeToSpeechLocale(String langCode) {
    final Map<String, String> mapper = {
      'en': 'en-US', // India English
      'kn': 'kn-IN', // Kannada
      'hi': 'hi-IN', // Hindi
      'ta': 'ta-IN', // Tamil
      'te': 'te-IN', // Telugu
      'ml': 'ml-IN', // Malayalam
    };
    return mapper[langCode] ?? 'en-IN';
  }

  /// Stop speech to text with proper cleanup
  static Future<void> stop() async {
    try {
      if (speech.isListening) {
        await speech.stop();
      }
    } catch (e) {
      logE('Error stopping speech recognition: $e');
    } finally {
      isListening(false);
      isListening.refresh();
      // _currentCallback = null;
    }
  }

  /// Cancel speech recognition immediately
  static Future<void> cancel() async {
    try {
      await speech.cancel();
    } catch (e) {
      logE('Error canceling speech recognition: $e');
    } finally {
      isListening(false);
      _currentCallback = null;
    }
  }

  /// Initialize the speech recognizer with enhanced error handling
  static Future<bool> _initializeSpeech() async {
    try {
      // Initialize without onStatus - it's not supported in initialize
      final bool available = await speech.initialize(
        onStatus: (String status) {
          logD('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            stop();
          }
        },
        onError: (SpeechRecognitionError error) async {
          logE('Speech recognition error: ${error.errorMsg}');

          if (error.errorMsg == 'error_no_match') {
            appSnackBar(
              message: 'Speech recognition error: No Match',
              type: SnackBarType.top,
              state: SnackBarState.danger,
            );
          } else if (error.errorMsg == 'error_speech_timeout') {
            appSnackBar(
              message: 'Speech recognition error: Timeout',
              type: SnackBarType.top,
              state: SnackBarState.danger,
            );
          } else {
            // All other errors → show warning
            appSnackBar(
              message: 'Voice search unavailable',
              type: SnackBarType.top,
              state: SnackBarState.danger,
            );
          }
          await stop();
        },
      );

      if (!available) {
        await stop();
        logE('Speech recognition not available on this device');
        appSnackBar(
          message: 'Voice search not available on this device',
          state: SnackBarState.warning,
        );
        return false;
      }

      // Log available locales for debugging
      final List<stt.LocaleName> locales = await speech.locales();
      logD(
        'Available speech locales: ${locales.map((stt.LocaleName l) => l.localeId).join(', ')}',
      );

      return true;
    } catch (e) {
      await stop();
      logE('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  /// Handle microphone permission error with better user guidance
  static Future<void> _handlePermissionError() async {
    try {
      await speech.cancel();
      await speech.stop();
    } catch (e) {
      logE('Error during permission cleanup: $e');
    }

    DialogManager.showMicrophoneAccessDialog(
      onPositiveClick: () {
        AppSettings.openAppSettings();
      },
    );
  }

  /// Check if speech recognition is available
  static Future<bool> isAvailable() async {
    try {
      return await speech.initialize();
    } catch (e) {
      logE('Error checking speech availability: $e');
      return false;
    }
  }

  /// Get the current listening state
  static bool get isCurrentlyListening =>
      isListening.value && speech.isListening;

  /// Reset the speech recognition system
  static Future<void> reset() async {
    await stop();
    _isInitialized = false;
    _currentCallback = null;
  }
}
