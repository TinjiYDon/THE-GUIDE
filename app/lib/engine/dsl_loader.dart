import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

class DslLoader {
  static Future<List<Map<String, dynamic>>> loadManifest() async {
    final manifestJson = await rootBundle.loadString('assets/content/manifest.json');
    final manifest = (json.decode(manifestJson) as Map<String, dynamic>);
    return (manifest['items'] as List).cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> loadSpecById(String testId) async {
    final manifestJson = await rootBundle.loadString('assets/content/manifest.json');
    final manifest = (json.decode(manifestJson) as Map<String, dynamic>);
    final String? path = (manifest['items'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((e) => e['id'] == testId, orElse: () => const {})['path'] as String?;
    if (path == null) {
      throw Exception('Spec not found for id: $testId');
    }
    final raw = await rootBundle.loadString('assets/content/$path');
    final doc = loadYaml(raw);
    return json.decode(json.encode(doc)) as Map<String, dynamic>;
  }
}

