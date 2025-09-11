import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
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

    // Skip initial auth check for now and go directly to unauthenticated state
    Future.delayed(Duration.zero, () => add(AuthStateChanged(false)));
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🎯 DEBUG: AuthBloc received AuthSignUpRequested event');
    print('🎯 DEBUG: Email: ${event.params.email}, Name: ${event.params.fullName}');
    emit(AuthLoading());
    print('🎯 DEBUG: AuthLoading state emitted, calling _signUp usecase');
    final result = await _signUp(event.params);
    print('🎯 DEBUG: _signUp usecase completed');
    result.fold(
      (failure) {
        print('🎯 DEBUG: Signup failed with error: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (_) {
        print('🎯 DEBUG: Signup successful, emitting AuthEmailVerificationRequired');
        emit(AuthEmailVerificationRequired(event.params.email));
      },
    );
  }


  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔐 DEBUG: SignIn requested for: ${event.params.email}');
    emit(AuthLoading());
    print('🔐 DEBUG: AuthLoading emitted, calling signIn');
    final result = await _signIn(event.params);
    print('🔐 DEBUG: SignIn completed');
    result.fold(
      (failure) {
        print('🔐 DEBUG: SignIn failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        print('🔐 DEBUG: SignIn successful: ${user.email}');
        emit(AuthAuthenticated(user));
      },
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
    print('🔍 DEBUG: AuthCheckRequested started');
    emit(AuthLoading());
    print('🔍 DEBUG: AuthLoading emitted, calling getCurrentUser');
    
    try {
      // Add timeout to prevent hanging
      final result = await _getCurrentUser(const NoParams()).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('🔍 DEBUG: getCurrentUser timed out');
          return const Left(AuthFailure('Authentication check timed out'));
        },
      );
      
      print('🔍 DEBUG: getCurrentUser completed');
      result.fold(
        (failure) {
          print('🔍 DEBUG: getCurrentUser failed: ${failure.message}');
          emit(AuthUnauthenticated());
        },
        (user) {
          print('🔍 DEBUG: getCurrentUser success, user: $user');
          if (user != null) {
            print('🔍 DEBUG: User found, emitting AuthAuthenticated');
            emit(AuthAuthenticated(user));
          } else {
            print('🔍 DEBUG: No user found, emitting AuthUnauthenticated');
            emit(AuthUnauthenticated());
          }
        },
      );
    } catch (e) {
      print('🔍 DEBUG: Exception in AuthCheck: $e');
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    print('🔄 DEBUG: AuthStateChanged event: isAuthenticated=${event.isAuthenticated}');
    if (!event.isAuthenticated) {
      print('🔄 DEBUG: User not authenticated, emitting AuthUnauthenticated');
      emit(AuthUnauthenticated());
    } else {
      print('🔄 DEBUG: User authenticated via stream, getting current user');
      // User is authenticated via stream, get the current user and emit AuthAuthenticated
      _getCurrentUser(const NoParams()).then((result) {
        result.fold(
          (failure) {
            print('🔄 DEBUG: Failed to get current user: ${failure.message}');
            emit(AuthUnauthenticated());
          },
          (user) {
            if (user != null) {
              print('🔄 DEBUG: Stream auth - User found, emitting AuthAuthenticated');
              emit(AuthAuthenticated(user));
            } else {
              print('🔄 DEBUG: Stream auth - No user found, emitting AuthUnauthenticated');
              emit(AuthUnauthenticated());
            }
          },
        );
      });
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}