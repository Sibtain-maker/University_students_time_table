import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp(SignUpParams params);
  Future<Either<Failure, UserEntity>> signIn(LoginParams params);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
}