class TestRunRecord {
  final int? id;
  final String testId;
  final String? seed;
  final int createdAt;
  final String? resultKey;
  final bool paidUsed;

  TestRunRecord({
    this.id,
    required this.testId,
    this.seed,
    required this.createdAt,
    this.resultKey,
    this.paidUsed = false,
  });

  Map<String, Object?> toRow() => {
        'id': id,
        'test_id': testId,
        'seed': seed,
        'created_at': createdAt,
        'result_key': resultKey,
        'paid_used': paidUsed ? 1 : 0,
      };

  static TestRunRecord fromRow(Map<String, Object?> row) => TestRunRecord(
        id: row['id'] as int?,
        testId: row['test_id'] as String,
        seed: row['seed'] as String?,
        createdAt: row['created_at'] as int,
        resultKey: row['result_key'] as String?,
        paidUsed: (row['paid_used'] as int? ?? 0) == 1,
      );
}

class AnswerRecord {
  final int runId;
  final String questionId;
  final String optionId;
  final String weightSnapshot; // json string

  AnswerRecord({
    required this.runId,
    required this.questionId,
    required this.optionId,
    required this.weightSnapshot,
  });

  Map<String, Object?> toRow() => {
        'run_id': runId,
        'question_id': questionId,
        'option_id': optionId,
        'weight_snapshot': weightSnapshot,
      };
}

