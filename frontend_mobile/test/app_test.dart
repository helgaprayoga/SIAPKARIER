import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_mobile/app.dart';

void main() {
  testWidgets('menampilkan halaman Home', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SiapKarierApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('SIAPKARIER'), findsOneWidget);
    expect(find.text('Career Readiness Check'), findsOneWidget);
  });
}
