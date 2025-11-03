class LocalAnalytics {
  static bool enabled = false; // 纯本地，可在设置中开关

  static final List<Map<String, Object?>> _events = [];

  static void log(String name, {Map<String, Object?> params = const {}}) {
    if (!enabled) return;
    _events.add({'name': name, 'params': params, 'ts': DateTime.now().millisecondsSinceEpoch});
  }

  static List<Map<String, Object?>> dump() => List.unmodifiable(_events);
  static void clear() => _events.clear();
}

