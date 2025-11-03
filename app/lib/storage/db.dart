import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDb {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'the_guide.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE tests_run (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  test_id TEXT NOT NULL,
  seed TEXT,
  created_at INTEGER NOT NULL,
  result_key TEXT,
  paid_used INTEGER DEFAULT 0
);
''');
        await db.execute('''
CREATE TABLE answers (
  run_id INTEGER,
  question_id TEXT,
  option_id TEXT,
  weight_snapshot TEXT,
  FOREIGN KEY(run_id) REFERENCES tests_run(id)
);
''');
        await db.execute('''
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT
);
''');
      },
    );
    return _db!;
  }

  static Future<int> insertTestRun({
    required String testId,
    String? seed,
    String? resultKey,
    bool paidUsed = false,
  }) async {
    final db = await instance();
    return db.insert('tests_run', {
      'test_id': testId,
      'seed': seed,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'result_key': resultKey,
      'paid_used': paidUsed ? 1 : 0,
    });
  }

  static Future<void> insertAnswer({
    required int runId,
    required String questionId,
    required String optionId,
    required String weightSnapshot,
  }) async {
    final db = await instance();
    await db.insert('answers', {
      'run_id': runId,
      'question_id': questionId,
      'option_id': optionId,
      'weight_snapshot': weightSnapshot,
    });
  }

  static Future<List<Map<String, Object?>>> queryRecentRuns({int limit = 50}) async {
    final db = await instance();
    return db.query('tests_run', orderBy: 'created_at DESC', limit: limit);
  }
}

