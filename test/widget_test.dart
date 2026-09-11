// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:taamol_tech/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:taamol_tech/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:taamol_tech/features/auth/presentation/widgets/language_selector_widget.dart';

void main() {
  testWidgets('New users see onboarding before signup', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://ekhegdzeowsuceorxtin.supabase.co',
      publishableKey: 'sb_publishable_3nUZ1BHOY-t1DhWwx254kw_XYcvWeKN',
    );
    addTearDown(() => Supabase.instance.client.auth.dispose());

    await tester.pumpWidget(const TkamolTechApp());
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('تخطي'), findsOneWidget);

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
    Supabase.instance.client.auth.stopAutoRefresh();
  });
}
