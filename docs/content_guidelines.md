# 内容与题库规范

- 题库以 YAML 存放于 `assets/content/`，通过 `manifest.json` 索引。
- `meta.id` 必须全局唯一；`meta.title` 用于 UI 展示。
- `questions[].options[].weights` 为分数字典，评估器会累加。
- `mapping.to_templates[]` 的 `when` 表达式支持 `>=`, `<=`, `==` 与 and 串联。
- `templates.*` 提供 `title/summary/advice[]` 字段。
- 合规：避免医疗/诊断措辞，明确娱乐用途。

