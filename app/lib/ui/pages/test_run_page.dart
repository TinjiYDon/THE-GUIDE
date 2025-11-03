import 'package:flutter/material.dart';

import '../../engine/dsl_loader.dart';
import '../../engine/evaluator.dart';
import 'result_page.dart';
import '../../storage/db.dart';
import 'dart:convert';

class TestRunPage extends StatefulWidget {
  const TestRunPage({super.key, required this.testId});
  final String testId;

  @override
  State<TestRunPage> createState() => _TestRunPageState();
}

class _TestRunPageState extends State<TestRunPage> {
  Map<String, dynamic>? _spec;
  final Map<String, String> _answers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final spec = await DslLoader.loadSpecById(widget.testId);
    setState(() {
      _spec = spec;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final spec = _spec!;
    final questions = (spec['questions'] as List).cast<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(title: Text(spec['meta']['title'] as String? ?? '测试')),
      body: ListView.builder(
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _answers.length == questions.length
                    ? () {
                        final result = Evaluator.evaluate(spec, _answers);
                        // 写入历史：run + answers
                        _saveRun(spec, _answers, result);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ResultPage(result: result),
                          ),
                        );
                      }
                    : null,
                child: const Text('查看结果'),
              ),
            );
          }

          final q = questions[index];
          final qid = q['id'] as String;
          final opts = (q['options'] as List).cast<Map<String, dynamic>>();
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q['text'] as String, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...opts.map((o) => RadioListTile<String>(
                        value: o['id'] as String,
                        groupValue: _answers[qid],
                        onChanged: (v) {
                          setState(() {
                            _answers[qid] = v!;
                          });
                        },
                        title: Text(o['text'] as String),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on _TestRunPageState {
  Future<void> _saveRun(Map<String, dynamic> spec, Map<String, String> answers, Map<String, dynamic> result) async {
    final runId = await AppDb.insertTestRun(
      testId: spec['meta']['id'] as String? ?? 'unknown',
      resultKey: result['template'] as String?,
    );
    final qs = (spec['questions'] as List).cast<Map<String, dynamic>>();
    for (final q in qs) {
      final qid = q['id'] as String;
      final selected = answers[qid];
      if (selected == null) continue;
      final opts = (q['options'] as List).cast<Map<String, dynamic>>();
      final opt = opts.firstWhere((o) => o['id'] == selected);
      final w = (opt['weights'] as Map?)?.cast<String, num>() ?? const {};
      await AppDb.insertAnswer(
        runId: runId,
        questionId: qid,
        optionId: selected,
        weightSnapshot: json.encode(w),
      );
    }
  }
}

