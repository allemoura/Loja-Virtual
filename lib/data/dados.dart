import 'package:cloud_firestore/cloud_firestore.dart';

class Dados{

  List categorias;

  Dados.fromDocument(DocumentSnapshot snapshot) {
    categorias = snapshot.data['cattegorias'];
  }

  Map<String, dynamic> dadosToMap() {
    return {
      'categorias' : categorias,
    };
  } 
  
}