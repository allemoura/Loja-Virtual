import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/favoritos_tile.dart';

class FavoritosTab extends StatefulWidget {
  int _currentIndex;

  FavoritosTab(this._currentIndex);

  @override
  _FavoritosTabState createState() => _FavoritosTabState(_currentIndex);
}

class _FavoritosTabState extends State<FavoritosTab> {
  int _currentIndex = 0;

  _FavoritosTabState(this._currentIndex);

  List produtosId = List();
  List produtos = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getProduto(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return eventos(context);
  }

  Widget eventos(context){
    setState(() {

    });
    if(UserModel.of(context).isLoggedIn()){
      if(produtosId.length == 0){
        return Container();
      }else if(produtos.length == 0) {
        return Center(child: CircularProgressIndicator(),);
      }else{  return ListView.builder(
            padding: EdgeInsets.all(4.0),
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              ProductData data = produtos[index];
              return FavoritosTile(data);
            });
      }
    }else{
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Faça o login para ver seu perfil!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
            RaisedButton(
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            )
          ],
        ),
      );
    }
  }

  void getProduto(context) async {
    List categoria = _getCategoria(context);
    List<ProductData> p = List();

    for (String c in categoria) {
      await Firestore.instance
          .collection('products')
          .document(c)
          .collection('items')
          .getDocuments()
          .then((value) {
        int i = 0;
        while (i < value.documents.length) {
          ProductData data = ProductData.fromDocument(value.documents[i]);
          data.categoria = c;

          if (produtosId.contains(data.id)) {
            p.add(data);
          }
          i++;
        }
      });
    }
    setState(() {
      produtos = p;
    });
  }

  List _getCategoria(context) {
    List categoria = List();
    UserModel.of(context).userData['favoritos'].forEach((key, value) {
      categoria.add(key);
      for (String p in value) {
        produtosId.add(p);
      }
    });

    setState(() {});
    return categoria;
  }
  
}
