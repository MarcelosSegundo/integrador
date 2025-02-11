import 'package:flutter/material.dart';
import '../services/firebase_auth.dart';
import '../services/firestore_servico.dart';
import 'cadastro.dart';
import 'tela_home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    String email = emailController.text.trim();
    String senha = passwordController.text.trim();

    try {
      var userCredential = await _authService.signInWithEmailAndPassword(email, senha);
      if (userCredential?.user == null) throw Exception("Erro ao fazer login.");

      // 🔹 Verifica no Firestore se o usuário existe
      bool userExists = await _firestoreService.userExists(userCredential!.user!.uid);
      if (!userExists) throw Exception("Usuário não encontrado no banco.");

      // 🔹 Se existir, navega para a tela Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FeedScreen()),
      );
    } catch (e) {
      _showSnackBar("Erro ao fazer login: ${e.toString()}");
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
                    onPressed: _login,
                    child: Text('Entrar'),
                  ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              ),
              child: Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
