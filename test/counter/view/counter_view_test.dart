import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ingenuity_flutter_app_template/counter/counter.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CounterView', () {
    testWidgets('renders current count', (tester) async {
      await tester.pumpApp(const CounterView());
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('tapping increment button updates the count', (tester) async {
      await tester.pumpApp(const CounterView());
      final incrementFinder = find.byIcon(Icons.add);
      expect(incrementFinder, findsOneWidget);

      await tester.tap(incrementFinder);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('tapping decrement button updates the count', (tester) async {
      await tester.pumpApp(const CounterView());
      final decrementFinder = find.byIcon(Icons.remove);
      expect(decrementFinder, findsOneWidget);

      await tester.tap(decrementFinder);
      await tester.pump();

      expect(find.text('-1'), findsOneWidget);
    });
  });
}
