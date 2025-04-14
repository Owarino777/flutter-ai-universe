import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Créer un compte",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: "Prénom",
                      prefixIcon: Icon(Icons.account_circle),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Nom",
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),

                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: "Confirmer le mot de passe",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  CustomButton(text: "S'inscrire", onPressed: _handleRegister),

                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Déjà inscrit ? Connectez-vous"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
