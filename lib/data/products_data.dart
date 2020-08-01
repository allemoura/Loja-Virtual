import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  bool promocao;

  String categoria;
  String id;

  String titulo;
  String descricao;

  double preco;

  int desconto;
  int vendido;

  List images;
  List tamanhos;

  Map comentarios = Map();
  Map avaliacao = Map();

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    titulo = snapshot.data['title'];
    descricao = snapshot.data['descricao'];
    preco = snapshot.data['preco'] + 0.0;
    images = snapshot.data['images'];
    tamanhos = snapshot.data['tamanhos'];
    comentarios = snapshot.data['comentarios'];
    avaliacao = snapshot.data['avaliacao'];
    promocao = snapshot.data['promocao'];
    desconto = snapshot.data['desconto'];
    vendido = snapshot.data['vendido'];
  }

  Map<String, dynamic> toResumedMap() {
    return {"titulo": titulo, "descricao": descricao, "preco": promocao ? getPrecoDesconto() : preco};
  }

  double getPrecoDesconto(){
    return preco - ((preco * desconto)/100);
  }

  Map<String, dynamic> productToMap() {
    return {
      'title': titulo,
      'descricao': descricao,
      'preco': preco,
      'images': images,
      'tamanhos': tamanhos,
      'comentarios': comentarios,
      'avaliacao': avaliacao,
      'desconto' : desconto,
      'promocao' : promocao,
      'vendido' : vendido
    };
  }
}
