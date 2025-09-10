import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationCode implements UseCase<void, ResendCodeParams> {
  final AuthRepository repository;

  ResendVerificationCode(this.repository);

  @override
  Future<Either<Failure, void>> call(ResendCodeParams params) async {
    return await repository.resendVerificationCode(params.email);
  }
}