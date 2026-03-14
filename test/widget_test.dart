import 'package:flutter_test/flutter_test.dart';
import 'package:rashify_app/core/service_locator.dart' as di;
import 'package:rashify_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rashify_app/main.dart';

void main() {
  testWidgets('Rashify app loads', (WidgetTester tester) async {
    await di.init();
    final authCubit = di.sl<AuthCubit>();
    await tester.pumpWidget(RashifyApp(authCubit: authCubit));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Rashify'), findsOneWidget);
  });
}
