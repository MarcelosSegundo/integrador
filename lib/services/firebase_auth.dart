import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Função para login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Inicia o processo de login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // O usuário cancelou o login
        return null;
      }

      // Obtém as credenciais do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria as credenciais para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Faz o login no Firebase com as credenciais
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Salva os dados do usuário no Firestore, se necessário
      if (userCredential.user != null) {
        await _firestore.collection("usuarios").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "email": userCredential.user!.email,
          "nome": userCredential.user!.displayName ?? "Desconhecido",
          "criadoEm": FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Erro ao fazer login com o Google: ${e.message}");
      return null;
    } catch (e) {
      print("Erro inesperado ao fazer login com o Google: $e");
      return null;
    }
  }

  // Função para login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Erro ao fazer login: ${e.message}");
      return null;
    } catch (e) {
      print("Erro inesperado ao fazer login: $e");
      return null;
    }
  }

  // Função para criar usuário com email e senha
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password, String nome) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        print("Erro: Usuário retornado como null.");
        return null;
      }

      // Salva os dados do usuário no Firestore
      await _firestore.collection("usuarios").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
        "nome": nome,
        "criadoEm": FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Erro de autenticação: ${e.message}");
      return null;
    } catch (e) {
      print("Erro inesperado ao cadastrar usuário: $e");
      return null;
    }
  }
}
