import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/rpg_transition.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscured = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _isObscured = !_isObscured);
  }

  Future<void> _handleRegister() async {
    final firstname = _firstNameController.text.trim();
    final lastname = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (firstname.isEmpty || lastname.isEmpty) {
      _showSnackbar("Veuillez renseigner prénom et nom");
      return;
    }

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar("Veuillez remplir tous les champs");
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar("Les mots de passe ne correspondent pas");
      return;
    }

    final success = await context.read<AuthProvider>().register(
      email: email,
      password: password,
      firstname: firstname,
      lastname: lastname,
    );

    if (success) {
      _showSnackbar("Inscription réussie !");
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      _showSnackbar("Un compte avec cet email existe déjà");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      fillColor: Colors.white.withOpacity(0.15),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? inputType}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label, Icon(icon)),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: _isObscured,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(
        label,
        const Icon(Icons.lock),
        suffix: IconButton(
          icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white),
          onPressed: _togglePasswordVisibility,
        ),
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
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Créer un Compte",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MedievalSharp',
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(2, 2)),
                            Shadow(blurRadius: 20, color: Colors.orangeAccent, offset: Offset(0, 0)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(_firstNameController, "Prénom", Icons.account_circle),
                      const SizedBox(height: 20),
                      _buildTextField(_lastNameController, "Nom", Icons.badge),
                      const SizedBox(height: 20),
                      _buildTextField(_emailController, "E-mail", Icons.email, inputType: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildPasswordField(_passwordController, "Mot de passe"),
                      const SizedBox(height: 20),
                      _buildPasswordField(_confirmPasswordController, "Confirmer le mot de passe"),
                      const SizedBox(height: 30),
                      CustomButton(text: "S'inscrire", onPressed: _handleRegister),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            buildRpgRoute(const LoginScreen(), type: TransitionType.scale),
                          );
                        },
                        child: const Text("Déjà inscrit ? Connectez-vous", style: TextStyle(color: Colors.white70)),
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
