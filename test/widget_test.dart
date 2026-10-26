import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/app.dart';

void main() {
  testWidgets('Mealora app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MealoraApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Mealora'), findsWidgets);
    expect(find.text('Explore categories'), findsOneWidget);
  });
}

