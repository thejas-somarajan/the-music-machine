import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ukelele_tuner/main.dart';

void main() {
  testWidgets('App loads without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const UkuleleTunerApp());
    await tester.pump();

    final hasTunerTitle = find.text('UKULELE TUNER').evaluate().isNotEmpty;
    final hasPermissionGate = find.text('Microphone Access').evaluate().isNotEmpty;
    expect(hasTunerTitle || hasPermissionGate, isTrue);
  });
}
