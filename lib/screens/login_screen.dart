import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/rpg_transition.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _handleLogin() async {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await context.read<AuthProvider>().login(username, password);

    if (success) {
      Navigator.pushReplacementNamed(context, '/rules');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Échec de la connexion")),
      );
    }
  }

  InputDecoration _inputDecoration(String label, Icon icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: IconTheme(
        data: const IconThemeData(color: Colors.amberAccent),
        child: icon,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white.withOpacity(0.15), // léger contraste
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amber, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/background_yodai_generated.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              tooltip: "Retour",
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/67eba439a03ec.png', height: 120),
                      const SizedBox(height: 20),
                      const Text(
                        "Entrez dans la Guilde",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MedievalSharp',
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(2, 2)),
                            Shadow(blurRadius: 20, color: Colors.amberAccent, offset: Offset(0, 0)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Nom du héros", const Icon(Icons.person)),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isObscured,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          "Code secret",
                          const Icon(Icons.key),
                          suffix: IconButton(
                            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.amberAccent),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: "Entrer dans l'aventure",
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            buildRpgRoute(const RegisterScreen(), type: TransitionType.scale),
                          );
                        },
                        child: const Text(
                          "Nouvel aventurier ? Inscription",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
