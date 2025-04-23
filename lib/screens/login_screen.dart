import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login_bloc.dart';
import '../repositories/auth_repository.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: Stack(
          children: [
            // Background color
            Container(color: const Color(0xFF0B0C69)),

            // Background image with fade
            Opacity(
              opacity: 0.4,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bagobo_pattern.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Main UI content
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/addu_seal.png", height: 80),
                      const SizedBox(height: 8),
                      const Text(
                        "UNIVENTS",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0xFF0B0C69),
                        ),
                      ),
                      const SizedBox(height: 24),

                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          } else if (state is LoginSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const DashboardScreen()),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is LoginLoading) {
                            return const CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(48),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            onPressed: () {
                              context
                                  .read<LoginBloc>()
                                  .add(LoginWithGooglePressed());
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://www.gstatic.com/marketing-cms/assets/images/d5/dc/cfe9ce8b4425b410b49b7f2dd3f3/g.webp=s48-fcrop64=1,00000000ffffffff-rw',
                                  height: 24,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Login with Google",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Switch(
                            value: rememberMe,
                            onChanged: (val) {
                              setState(() {
                                rememberMe = val;
                              });
                            },
                          ),
                          const Text("Remember Me"),
                        ],
                      ),

                      const Text.rich(
                        TextSpan(
                          text: "",
                          children: [
                            TextSpan(
                              text: "ADMIN ONLY",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
