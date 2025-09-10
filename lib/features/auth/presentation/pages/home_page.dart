import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<AuthBloc>(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FadeInDown(
                              duration: const Duration(milliseconds: 600),
                              child: const Icon(
                                Icons.schedule,
                                size: 120,
                                color: Colors.blue,
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
                            FadeInUp(
                              duration: const Duration(milliseconds: 800),
                              child: Text(
                                'Welcome to\nUniversity Timetable',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  height: 1.2,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: Text(
                                'Hello ${state.user.fullName ?? state.user.email}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 60),
                            
                            FadeInUp(
                              duration: const Duration(milliseconds: 1200),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.blue[600],
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Your timetable management features will be available here soon!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue[700],
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Sign out button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: CustomButton(
                              text: 'Sign Out',
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthSignOutRequested());
                              },
                              backgroundColor: Colors.red[400],
                              isLoading: state is AuthLoading,
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }
            
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}