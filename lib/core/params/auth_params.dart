import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String fullName;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object> get props => [email, password, fullName];
}

class VerifyEmailParams extends Equatable {
  final String email;
  final String token;

  const VerifyEmailParams({
    required this.email,
    required this.token,
  });

  @override
  List<Object> get props => [email, token];
}

class ResendCodeParams extends Equatable {
  final String email;

  const ResendCodeParams({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}