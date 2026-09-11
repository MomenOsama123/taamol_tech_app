import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

Future<AuthResponse> signUp({
  required String email,
  required String password,
  Map<String, dynamic>? data,
}) {
  return _supabase.auth.signUp(email: email, password: password, data: data);
}

Future<AuthResponse> signIn({required String email, required String password}) {
  return _supabase.auth.signInWithPassword(email: email, password: password);
}

Future<bool> isCurrentUserAdmin() async {
  final user = _supabase.auth.currentUser;
  if (user == null) return false;

  final profile = await _supabase
      .from('profiles')
      .select('is_admin')
      .eq('id', user.id)
      .maybeSingle();

  return profile?['is_admin'] == true;
}
