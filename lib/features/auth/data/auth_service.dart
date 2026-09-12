import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

/// 🔹 إنشاء حساب جديد
Future<AuthResponse> signUp({
  required String email,
  required String password,
  Map<String, dynamic>? data,
}) {
  return _supabase.auth.signUp(email: email, password: password, data: data);
}

/// 🔹 تسجيل الدخول
Future<AuthResponse> signIn({required String email, required String password}) {
  return _supabase.auth.signInWithPassword(email: email, password: password);
}

/// 🔹 تسجيل الخروج
Future<void> signOut() async {
  await _supabase.auth.signOut();
}

/// 🔹 التحقق مما إذا كان المستخدم الحالي الأدمن
Future<bool> isCurrentUserAdmin() async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('profiles')
        .select('is_admin')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      final dynamic rawIsAdmin = response['is_admin'];

      // تحويل مرن يغطي حالات bool أو String أو int
      return rawIsAdmin == true ||
          rawIsAdmin.toString().toLowerCase() == 'true' ||
          rawIsAdmin == 1;
    }
    return false;
  } catch (e) {
    debugPrint('Error checking admin status: $e');
    return false;
  }
}

/// 🔹 الاسم البديل للدالة لضمان التوافق
Future<bool> checkIsAdmin() => isCurrentUserAdmin();
