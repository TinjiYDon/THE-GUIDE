import 'package:flutter/material.dart';

import '../../storage/db.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, Object?>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AppDb.queryRecentRuns(limit: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史记录')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data!;
          if (rows.isEmpty) {
            return const Center(child: Text('暂无记录'));
          }
          return ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final r = rows[index];
              final title = r['test_id'] as String? ?? '-';
              final result = r['result_key'] as String? ?? '';
              final ts = DateTime.fromMillisecondsSinceEpoch((r['created_at'] as int?) ?? 0);
              return ListTile(
                title: Text(title),
                subtitle: Text('${ts.toLocal()}'),
                trailing: Text(result),
              );
            },
          );
        },
      ),
    );
  }
}

