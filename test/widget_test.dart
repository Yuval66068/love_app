import 'package:flutter_test/flutter_test.dart';
import 'package:love_app/main.dart';

void main() {
  testWidgets('Love app loads its home screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Love App'), findsOneWidget);
    expect(find.text('Share the love'), findsOneWidget);
  });
}
