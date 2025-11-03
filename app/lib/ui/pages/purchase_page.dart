import 'package:flutter/material.dart';

import '../../purchase/billing.dart';
import '../../storage/prefs.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  bool _pro = false;
  final _billing = BillingService();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final pro = await AppPrefs.getProUnlocked();
    setState(() => _pro = pro);
    await _billing.init(onProUnlocked: (ok) async {
      if (ok) {
        await AppPrefs.setProUnlocked(true);
        if (mounted) setState(() => _pro = true);
      }
    });
  }

  @override
  void dispose() {
    _billing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('解锁 Pro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_pro ? '已解锁 Pro' : '未解锁 Pro', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const Text('一次性解锁全部题库与主题，离线使用，隐私安全。'),
            const Spacer(),
            FilledButton(
              onPressed: _pro
                  ? null
                  : () async {
                      // 占位：实际需调用 in_app_purchase 的购买流程
                      // 这里先本地置 Pro，便于无商店环境下联调 UI
                      await AppPrefs.setProUnlocked(true);
                      if (mounted) setState(() => _pro = true);
                    },
              child: Text(_pro ? '已拥有' : '解锁 Pro'),
            ),
          ],
        ),
      ),
    );
  }
}

