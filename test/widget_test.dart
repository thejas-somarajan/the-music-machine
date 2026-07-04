import 'package:flutter_test/flutter_test.dart';
import 'package:ukelele_tuner/main.dart';

void main() {
  testWidgets('App shell loads with five navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const UkuleleCoachApp());
    await tester.pump();

    expect(find.text('Tuner'), findsOneWidget);
    expect(find.text('Metronome'), findsOneWidget);
    expect(find.text('Chords'), findsOneWidget);
    expect(find.text('Songs'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);

    final hasTunerTitle = find.text('THE MUSIC MACHINE').evaluate().isNotEmpty;
    final hasPermissionGate = find.text('Microphone Access').evaluate().isNotEmpty;
    expect(hasTunerTitle || hasPermissionGate, isTrue);
  });
}
