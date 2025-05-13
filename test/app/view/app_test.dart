import 'package:flutter_test/flutter_test.dart';
import 'package:ingenuity_flutter_app_template/app/app.dart';
import 'package:ingenuity_flutter_app_template/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
