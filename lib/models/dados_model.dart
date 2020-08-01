import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:scoped_model/scoped_model.dart';

class DadosModel extends Model {
  List categorias = List();
  List<ProductData> _maisVendidos = List();
  List<ProductData> _produtosPromocao = List();

  DadosModel();

  static DadosModel of(BuildContext context) =>
      ScopedModel.of<DadosModel>(context);
  
  _setDados() async{
    
    await Firestore.instance.collection('controler').document("data").get().then((value) => categorias = value.data['categorias']);
    notifyListeners();
  }

  _setProdutos() async {
    List<ProductData> p = List();
    List<ProductData> p2 = List();
    for (String c in categorias) {
      print(c);
      await Firestore.instance
          .collection('products')
          .document(c)
          .collection('items')
          .getDocuments()
          .then(
            (value) {
              int i = 0;
              while (i < value.documents.length) {
                ProductData data = ProductData.fromDocument(value.documents[i]);
                data.categoria = c;
                if(data.promocao){
                  p2.add(data);
                }
                p.add(data);
                i++;
          }
      });
    }
    _ordenaMaisVendidos(p);

    _maisVendidos = p;
    _produtosPromocao = p2;
    notifyListeners();
  }

  _ordenaMaisVendidos(List produtos){
    produtos.sort((a,b){
      return b.vendido.compareTo(a.vendido); 
    });
    notifyListeners();
    return produtos;   
  }

  List<ProductData> getMaisVendidos(){
    return _maisVendidos;
  }

  List<ProductData> getProdutosPromocao(){
    _setProdutos();
    return _produtosPromocao;
  }
}