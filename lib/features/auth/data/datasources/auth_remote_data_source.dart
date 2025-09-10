import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(SignUpParams params);
  Future<UserModel> signIn(LoginParams params);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signUp(SignUpParams params) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: params.email,
        password: params.password,
        data: {'full_name': params.fullName},
      );

      if (response.user == null) {
        throw const AuthFailure('Failed to create user');
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