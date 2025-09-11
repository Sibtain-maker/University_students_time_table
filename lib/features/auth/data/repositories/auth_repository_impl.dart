import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> signUp(SignUpParams params) async {
    try {
      print('🎯 DEBUG: AuthRepository signUp called, calling remoteDataSource');
      await remoteDataSource.signUp(params);
      print('🎯 DEBUG: AuthRepository signUp completed successfully');
      return const Right(null);
    } on Failure catch (failure) {
      print('🎯 DEBUG: AuthRepository caught Failure: ${failure.message}');
      return Left(failure);
    } catch (e) {
      print('🎯 DEBUG: AuthRepository caught generic exception: $e');
      return Left(AuthFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, UserEntity>> signIn(LoginParams params) async {
    try {
      final user = await remoteDataSource.signIn(params);
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }
}