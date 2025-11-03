import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CardRenderer {
  static Future<ui.Image> renderShareImage({
    required Size size,
    required String title,
    required String summary,
    String watermark = '@THE GUIDE · 离线生成',
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final rect = Offset.zero & size;
    final bgPaint = Paint()..color = const Color(0xFF0F0F1A);
    canvas.drawRect(rect, bgPaint);

    final tpTitle = _textPainter(
      title,
      const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      maxWidth: size.width - 40,
    );
    tpTitle.paint(canvas, const Offset(20, 24));

    final tpSummary = _textPainter(
      summary,
      const TextStyle(color: Colors.white70, fontSize: 16),
      maxWidth: size.width - 40,
    );
    tpSummary.paint(canvas, Offset(20, 24 + tpTitle.height + 12));

    final tpWatermark = _textPainter(
      watermark,
      const TextStyle(color: Colors.white30, fontSize: 12),
      maxWidth: size.width - 40,
    );
    tpWatermark.paint(canvas, Offset(20, size.height - tpWatermark.height - 16));

    final picture = recorder.endRecording();
    return picture.toImage(size.width.toInt(), size.height.toInt());
  }

  static Future<List<int>> renderSharePngBytes({
    required Size size,
    required String title,
    required String summary,
    String watermark = '@THE GUIDE · 离线生成',
  }) async {
    final img = await renderShareImage(
      size: size,
      title: title,
      summary: summary,
      watermark: watermark,
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static TextPainter _textPainter(String text, TextStyle style, {required double maxWidth}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 10,
      ellipsis: '…',
    );
    tp.layout(maxWidth: maxWidth);
    return tp;
  }
}

