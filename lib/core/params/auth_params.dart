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