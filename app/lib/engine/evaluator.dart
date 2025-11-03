import 'dart:math';

class Evaluator {
  static Map<String, dynamic> evaluate(
    Map<String, dynamic> spec,
    Map<String, String> answers,
  ) {
    final weights = <String, num>{};
    final questions = (spec['questions'] as List).cast<Map<String, dynamic>>();
    for (final q in questions) {
      final qid = q['id'] as String;
      final selected = answers[qid];
      if (selected == null) continue;
      final opts = (q['options'] as List).cast<Map<String, dynamic>>();
      final opt = opts.firstWhere((o) => o['id'] == selected);
      final w = (opt['weights'] as Map?)?.cast<String, num>() ?? const {};
      for (final entry in w.entries) {
        weights.update(entry.key, (value) => value + entry.value, ifAbsent: () => entry.value);
      }
    }

    // pick template by simple rule: first match in mapping
    final mapping = (spec['mapping'] as Map<String, dynamic>);
    final toTemplates = (mapping['to_templates'] as List).cast<Map<String, dynamic>>();
    String? chosen;
    for (final rule in toTemplates) {
      final when = rule['when'] as String?;
      if (when == null || _match(when, weights)) {
        chosen = rule['template'] as String;
        break;
      }
    }
    chosen ??= ((spec['templates'] as Map).keys.first as String);

    final tpl = (spec['templates'] as Map<String, dynamic>)[chosen] as Map<String, dynamic>;
    return {
      'title': tpl['title'] ?? '结果',
      'summary': tpl['summary'] ?? '',
      'advice': (tpl['advice'] as List?)?.cast<String>() ?? const <String>[],
      'weights': weights,
      'template': chosen,
    };
  }

  static bool _match(String expr, Map<String, num> weights) {
    // minimal parser: supports `key >= N` joined by 'and'
    final parts = expr.split(RegExp(r'\s+and\s+', caseSensitive: false));
    for (final p in parts) {
      final m = RegExp(r'^(\w+)\s*(>=|<=|==)\s*([0-9]+)$').firstMatch(p.trim());
      if (m == null) return false;
      final key = m.group(1)!;
      final op = m.group(2)!;
      final val = num.parse(m.group(3)!);
      final got = weights[key] ?? 0;
      switch (op) {
        case '>=':
          if (got < val) return false;
          break;
        case '<=':
          if (got > val) return false;
          break;
        case '==':
          if ((got - val).abs() > 1e-9) return false;
          break;
      }
    }
    return true;
  }
}

