import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignIn implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.signIn(params);
  }
}