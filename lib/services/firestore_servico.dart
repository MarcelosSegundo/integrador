import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Salvar usuário no Firestore
  Future<void> saveUser(String uid, String name, String email) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  // 🔹 NOVO: Verifica se o usuário existe no Firestore
  Future<bool> userExists(String uid) async {
    var userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.exists;
  }
}
