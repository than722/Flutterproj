import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _goToDashboard();
    } on FirebaseAuthException catch (e) {
      _showError(e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // user cancelled
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _goToDashboard();
    } on FirebaseAuthException catch (e) {
      _showError(e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Dashboard()),
    );
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'Authentication error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // allow Scaffold to resize when keyboard appears
      resizeToAvoidBottomInset: true, // FIX: ensure keyboard pushes up content
      body: Stack(
        children: [
          // CHANGED: deeper blue background + pattern
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1),
              image: const DecorationImage(
                image: AssetImage('assets/pattern.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            // FIX: scrollable content that respects keyboard inset
            child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: Column(
                children: [
                  // CHANGED: larger logo
                  Image.asset(
                    'assets/AdDU_logo.png',
                    height: 180,
                  ),
                  const SizedBox(height: 12),

                  // CHANGED: UNIVENTS with semi-opaque cover
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'UNIVENTS',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF0D47A1),
                        decorationThickness: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CHANGED: sign-in card pinned near bottom via padding
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign in',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        // Email field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'abc@email.com',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),

                        // Remember Me + Forgot Password
                        Row(
                          children: [
                            Switch(
                              value: rememberMe,
                              activeColor: Colors.blue.shade800,
                              onChanged: (v) =>
                                  setState(() => rememberMe = v),
                            ),
                            const Text('Remember Me'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // CHANGED: custom two-tone SIGN IN button wrapped in GestureDetector
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onTap: _signInWithEmail,
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      // main “SIGN IN” block
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade800,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(30),
                                              bottomLeft:
                                                  Radius.circular(30),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'SIGN IN',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // circular arrow block
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade900,
                                          borderRadius:
                                              const BorderRadius.only(
                                            topRight:
                                                Radius.circular(30),
                                            bottomRight:
                                                Radius.circular(30),
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        const SizedBox(height: 24),

                        // OR divider
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              child: Text('OR'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Google Sign-In button
                        SizedBox(
                          height: 50,
                          child: SignInButton(
                            Buttons.Google,
                            text: 'Login with Google',
                            onPressed: _signInWithGoogle,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign up prompt
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                                "Don't have an account? "),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

