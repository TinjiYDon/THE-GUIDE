import 'package:flutter/material.dart';

import '../../engine/dsl_loader.dart';
import '../../storage/prefs.dart';
import 'purchase_page.dart';
import 'test_run_page.dart';

class TestListPage extends StatefulWidget {
  const TestListPage({super.key});

  @override
  State<TestListPage> createState() => _TestListPageState();
}

class _TestListPageState extends State<TestListPage> {
  late Future<({List<Map<String, dynamic>> items, bool pro})> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<({List<Map<String, dynamic>> items, bool pro})> _load() async {
    final items = await DslLoader.loadManifest();
    final pro = await AppPrefs.getProUnlocked();
    return (items: items, pro: pro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择测试')),
      body: FutureBuilder<({List<Map<String, dynamic>> items, bool pro})>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!.items;
          final pro = snapshot.data!.pro;
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final it = items[index];
              final id = it['id'] as String;
              final title = (it['title'] as String?) ?? id;
              final free = (it['free'] as bool?) ?? true;
              final locked = !free && !pro;
              return ListTile(
                title: Text(title + (free ? '（免费）' : '')),
                trailing: locked ? const Icon(Icons.lock_outline) : const Icon(Icons.chevron_right),
                onTap: () {
                  if (locked) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PurchasePage()),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => TestRunPage(testId: id)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

