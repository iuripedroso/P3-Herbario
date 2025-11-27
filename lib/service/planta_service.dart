import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantas/model/planta_model.dart';

class PlantaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _plantasRef {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');
    return _firestore.collection('users').doc(uid).collection('plantas');
  }

  // Salvar uma nova planta
  Future<void> salvarPlanta(Planta planta) async {
    try {
      await _plantasRef.add(planta.toMap());
    } catch (e) {
      throw Exception('Erro ao salvar planta: $e');
    }
  }

  // Atualizar uma planta existente
  Future<void> atualizarPlanta(Planta planta) async {
    try {
      if (planta.id == null) throw Exception('ID da planta não encontrado');
      await _plantasRef.doc(planta.id).update(planta.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar planta: $e');
    }
  }

  // Deletar uma planta
  Future<void> deletarPlanta(String id) async {
    try {
      await _plantasRef.doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar planta: $e');
    }
  }

   Future<Planta?> buscarPlanta(String id) async {
    try {
      final doc = await _plantasRef.doc(id).get();
      if (doc.exists) {
        return Planta.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar planta: $e');
    }
  }

 
  Stream<List<Planta>> buscarTodasPlantas() {
    try {
      return _plantasRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Planta.fromMap(doc.data(), doc.id);
        }).toList();
      });
    } catch (e) {
      throw Exception('Erro ao buscar plantas: $e');
    }
  }
}