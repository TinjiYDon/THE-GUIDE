import 'package:flutter/material.dart';

import '../../storage/prefs.dart';
import '../../telemetry/local_analytics.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _telemetry = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await AppPrefs.getTelemetryEnabled();
    setState(() {
      _telemetry = enabled;
      LocalAnalytics.enabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('启用本地统计（不上传，仅本机）'),
            value: _telemetry,
            onChanged: (v) async {
              await AppPrefs.setTelemetryEnabled(v);
              setState(() {
                _telemetry = v;
                LocalAnalytics.enabled = v;
              });
            },
          ),
        ],
      ),
    );
  }
}

