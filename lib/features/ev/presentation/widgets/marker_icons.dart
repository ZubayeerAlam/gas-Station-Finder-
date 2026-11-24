import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Draws "pill" map markers with a text label (e.g. "150 kW") and caches them.
class PillMarkerIcons {
  final _cache = <String, Future<BitmapDescriptor>>{};

  Future<BitmapDescriptor> get(
    String label, {
    required Color background,
    required Color foreground,
    required double dpr,
  }) => _cache.putIfAbsent('$label|${background.toARGB32()}|$dpr', () => _draw(label, background, foreground, dpr));

  static Future<BitmapDescriptor> _draw(String label, Color bg, Color fg, double dpr) async {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: 12 * dpr, fontWeight: FontWeight.w700, color: fg),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final padH = 8 * dpr, padV = 4 * dpr, tail = 6 * dpr, border = 1.5 * dpr;
    final w = tp.width + padH * 2, h = tp.height + padV * 2;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final body = RRect.fromRectAndRadius(Rect.fromLTWH(border, border, w, h), Radius.circular(h / 2));
    final pin = Path()
      ..moveTo(border + w / 2 - tail, border + h - 1)
      ..lineTo(border + w / 2, border + h + tail)
      ..lineTo(border + w / 2 + tail, border + h - 1)
      ..close();
    final outline = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = border * 2;
    canvas
      ..drawRRect(body, outline)
      ..drawPath(pin, outline)
      ..drawRRect(body, Paint()..color = bg)
      ..drawPath(pin, Paint()..color = bg);
    tp.paint(canvas, Offset(border + padH, border + padV));
    final image = await recorder.endRecording().toImage((w + border * 2).ceil(), (h + tail + border * 2).ceil());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List(), imagePixelRatio: dpr);
  }
}
