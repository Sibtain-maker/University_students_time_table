import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/params/auth_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<void, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    print('🎯 DEBUG: SignUp usecase called with email: ${params.email}');
    final result = await repository.signUp(params);
    print('🎯 DEBUG: SignUp usecase completed, returning result');
    return result;
  }
}