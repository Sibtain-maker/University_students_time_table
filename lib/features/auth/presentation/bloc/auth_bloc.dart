import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;
  final SignIn _signIn;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final AuthRepository _authRepository;
  late StreamSubscription _authStateSubscription;

  AuthBloc({
    required SignUp signUp,
    required SignIn signIn,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required AuthRepository authRepository,
  })  : _signUp = signUp,
        _signIn = signIn,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthStateChanged(user != null));
    });

    add(AuthCheckRequested());
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signUp(event.params);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signIn(event.params);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signOut(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => user != null 
          ? emit(AuthAuthenticated(user))
          : emit(AuthUnauthenticated()),
    );
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (!event.isAuthenticated) {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}