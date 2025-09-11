import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart' as auth_states;
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  
  await initializeDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp(
        title: 'University Timetable',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'SF Pro Display',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, auth_states.AuthState>(
      listener: (context, state) {
        print('🏠 DEBUG: AuthWrapper listener - state: ${state.runtimeType}');
      },
      builder: (context, state) {
        print('🏠 DEBUG: AuthWrapper builder - state: ${state.runtimeType}');
        if (state is auth_states.AuthAuthenticated) {
          print('🏠 DEBUG: User authenticated, showing HomePage');
          return const HomePage();
        } else if (state is auth_states.AuthUnauthenticated) {
          print('🏠 DEBUG: User not authenticated, showing LoginPage');
          return const LoginPage();
        } else if (state is auth_states.AuthEmailVerificationRequired) {
          print('🏠 DEBUG: Email verification required, showing LoginPage');
          return const LoginPage();
        } else if (state is auth_states.AuthLoading) {
          print('🏠 DEBUG: Auth loading, showing spinner');
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is auth_states.AuthInitial) {
          print('🏠 DEBUG: Auth initial state, showing spinner');
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is auth_states.AuthError) {
          print('🏠 DEBUG: Auth error state, showing LoginPage');
          return const LoginPage();
        } else {
          print('🏠 DEBUG: Unknown state: ${state.runtimeType}, showing LoginPage');
          return const LoginPage();
        }
      },
    );
  }
}
