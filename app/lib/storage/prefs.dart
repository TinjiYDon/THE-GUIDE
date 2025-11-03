import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const _kProUnlocked = 'pro_unlocked';
  static const _kTelemetryEnabled = 'telemetry_enabled';

  static Future<bool> getProUnlocked() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kProUnlocked) ?? false;
  }

  static Future<void> setProUnlocked(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kProUnlocked, value);
  }

  static Future<bool> getTelemetryEnabled() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kTelemetryEnabled) ?? false;
  }

  static Future<void> setTelemetryEnabled(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kTelemetryEnabled, value);
  }
}

