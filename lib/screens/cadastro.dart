import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/firebase_auth.dart';
import '../services/firestore_servico.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Erro ao inicializar o Firebase: $e");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // Validações
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) => password.length >= 6;
  bool isValidName(String name) => name.length >= 3;

  Future<void> _register() async {
    String email = emailController.text.trim();
    String senha = passwordController.text.trim();
    String nome = nameController.text.trim();

    if (!isValidEmail(email)) {
      _showSnackBar("Email inválido!");
      return;
    }
    if (!isValidPassword(senha)) {
      _showSnackBar("A senha deve ter pelo menos 6 caracteres!");
      return;
    }
    if (!isValidName(nome)) {
      _showSnackBar("O nome deve ter pelo menos 3 caracteres!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      var userCredential = await _authService.createUserWithEmailAndPassword(email, senha, nome);
      if (userCredential?.user == null) throw Exception("Erro ao criar usuário.");

      await _firestoreService.saveUser(userCredential!.user!.uid, nome, email);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showSnackBar("Erro ao cadastrar: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}
