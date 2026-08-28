import 'package:flutter_test/flutter_test.dart';
import 'package:love_app/main.dart';

void main() {
  testWidgets('Love app shows question and buttons and accepts yes', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify question
    expect(find.text('את אוהבת אותי?'), findsOneWidget);

    // Both buttons should be present ("כן" and "לא")
    expect(find.text('כן'), findsOneWidget);
    expect(find.text('לא'), findsOneWidget);

    // Tap the yes button
    await tester.tap(find.text('כן'));
    await tester.pumpAndSettle();

    // After tapping yes, confirmation text should appear
    expect(find.textContaining('ידעתי שתבחרי כן'), findsOneWidget);
  });
}
