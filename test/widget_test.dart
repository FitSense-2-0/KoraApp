import 'package:kora_mobile/app/kora_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'AdheSyn inicia correctamente',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const KoraApp(),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(KoraApp),
        findsOneWidget,
      );
    },
  );
}