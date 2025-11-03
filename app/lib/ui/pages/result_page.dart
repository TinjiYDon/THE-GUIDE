import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../render/card_renderer.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.result});
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    final title = result['title'] as String? ?? '结果';
    final summary = result['summary'] as String? ?? '';
    final advice = (result['advice'] as List?)?.cast<String>() ?? const <String>[];

    return Scaffold(
      appBar: AppBar(title: const Text('测试结果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(summary),
            const SizedBox(height: 16),
            if (advice.isNotEmpty) ...[
              Text('建议', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...advice.map((a) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('· $a'),
                  )),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final bytes = await CardRenderer.renderSharePngBytes(
            size: const Size(1080, 1920),
            title: title,
            summary: summary,
          );
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/the_guide_result.png');
          await file.writeAsBytes(bytes, flush: true);
          await Share.shareXFiles([XFile(file.path)], text: '我的测试结果');
        },
        label: const Text('分享'),
        icon: const Icon(Icons.share),
      ),
    );
  }
}

