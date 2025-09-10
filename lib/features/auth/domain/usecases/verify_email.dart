import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyEmail implements UseCase<UserEntity, VerifyEmailParams> {
  final AuthRepository repository;

  VerifyEmail(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyEmailParams params) async {
    return await repository.verifyEmail(params.email, params.token);
  }
}