import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(SignUpParams params);
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
      print('🔄 Attempting to sign up user: ${params.email}');
      
      // Sign up with email link verification
      await supabaseClient.auth.signUp(
        email: params.email,
        password: params.password,
        data: {
          'full_name': params.fullName,
        },
      );

      print('✅ Signup completed successfully');
      print('📧 Verification email sent to: ${params.email}');
      print('⚠️  Please check spam folder if not received');
      
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      print('📊 Status Code: ${e.statusCode}');
      throw AuthFailure('Failed to create account: ${e.message}');
    } catch (e) {
      print('💥 General Exception: $e');
      throw AuthFailure('Account creation failed: $e');
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
      print('👤 DEBUG: Getting current user from Supabase');
      final user = supabaseClient.auth.currentUser;
      print('👤 DEBUG: Current user: $user');
      if (user == null) {
        print('👤 DEBUG: No current user found');
        return null;
      }

      print('👤 DEBUG: User found: ${user.email}');
      final userModel = UserModel(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] as String?,
        createdAt: DateTime.parse(user.createdAt),
      );
      print('👤 DEBUG: UserModel created successfully');
      return userModel;
    } catch (e) {
      print('👤 DEBUG: Error in getCurrentUser: $e');
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