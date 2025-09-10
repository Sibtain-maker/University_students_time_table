import 'package:equatable/equatable.dart';
import '../../../../core/params/auth_params.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignUpRequested extends AuthEvent {
  final SignUpParams params;

  const AuthSignUpRequested(this.params);

  @override
  List<Object> get props => [params];
}

class AuthSignInRequested extends AuthEvent {
  final LoginParams params;

  const AuthSignInRequested(this.params);

  @override
  List<Object> get props => [params];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;

  const AuthStateChanged(this.isAuthenticated);

  @override
  List<Object> get props => [isAuthenticated];
}