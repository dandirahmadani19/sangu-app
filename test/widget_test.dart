import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sangu/main.dart';

void main() {
  testWidgets('SanguApp menampilkan placeholder', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SanguApp()));

    expect(find.text('Sangu'), findsOneWidget);
  });
}
