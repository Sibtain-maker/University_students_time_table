import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(SignUpParams params);
  Future<UserModel> verifyEmail(String email, String token);
  Future<void> resendVerificationCode(String email);
  Future<UserModel> signIn(LoginParams params);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> signUp(SignUpParams params) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: params.email,
        password: params.password,
        data: {'full_name': params.fullName},
        emailRedirectTo: null, // This ensures email verification is required
      );

      if (response.user == null) {
        throw const AuthFailure('Failed to create user');
      }

      // User created but needs email verification
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> verifyEmail(String email, String token) async {
    try {
      final response = await supabaseClient.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );

      if (response.user == null) {
        throw const AuthFailure('Failed to verify email');
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        fullName: response.user!.userMetadata?['full_name'] as String?,
        createdAt: DateTime.parse(response.user!.createdAt),
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> resendVerificationCode(String email) async {
    try {
      await supabaseClient.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> signIn(LoginParams params) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: params.email,
        password: params.password,
      );

      if (response.user == null) {
        throw const AuthFailure('Failed to sign in');
      }

      return UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        fullName: response.user!.userMetadata?['full_name'] as String?,
        createdAt: DateTime.parse(response.user!.createdAt),
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      return UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] as String?,
        createdAt: DateTime.parse(user.createdAt),
      );
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;

      return UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] as String?,
        createdAt: DateTime.parse(user.createdAt),
      );
    });
  }
}