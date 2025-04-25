import 'package:flutter/gestures.dart';
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

            // Pattern overlay
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

            // Main Content
            Column(
              children: [
                const SizedBox(height: 60),

                // Logo and UNIVENTS title
                Column(
                  children: [
                    Image.asset("assets/images/addu_seal.png", height: 150),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF0B0C69),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "UNIVENTS",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Georgia',
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Login Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sign in", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "abc@email.com",
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Your password",
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                            TextButton(
                              onPressed: () {}, // Add Forgot Password function
                              child: const Text("Forgot Password?"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // SIGN IN button
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Add login logic
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B0C69),
                                elevation: 1,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                  SizedBox(width: 12),
                                  Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Center(child: Text("OR")),
                        const SizedBox(height: 16),

                        // Google Login Button
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            } else if (state is LoginSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 280),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<LoginBloc>().add(LoginWithGooglePressed());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 1,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: const BorderSide(color: Colors.transparent),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                                        height: 20,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.error, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Login with Google",
                                        style: TextStyle(
                                          color: Color(0xFF202124),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: const TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle sign-up logic
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
