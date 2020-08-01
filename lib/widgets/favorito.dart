import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';

class Favorito extends StatefulWidget {
  final String productId;
  final double size;
  final double padding;
  final String categoria;

  Favorito(this.productId, this.size, this.padding, this.categoria);

  @override
  _FavoritoState createState() =>
      _FavoritoState(productId, size, padding, categoria);
}

class _FavoritoState extends State<Favorito> {
  final String productId;
  final double padding;
  final double size;
  final String categoria;

  _FavoritoState(this.productId, this.size, this.padding, this.categoria);

  bool favorito;

  List favoritosCat;

  Map favoritos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    isFavorito();

    atualizarFavoritosCat();

    atualizarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return favorito
        ? IconButton(
            padding: EdgeInsets.fromLTRB(padding, 0.0, 0.0, 0.0),
            icon: Icon(
              Icons.favorite,
              color: Colors.redAccent,
              size: size,
            ),
            onPressed: () {
              favoritosCat = removeProduto(favoritosCat, productId);

              favoritos[categoria] = favoritosCat;

              setFavoritos(favoritos);

              setState(() {
                atualizarFavoritos();
                isFavorito();
                atualizarFavoritosCat();
              });
            })
        : IconButton(
            padding: EdgeInsets.fromLTRB(padding, 0.0, 0.0, 0.0),
            icon: Icon(
              Icons.favorite_border,
              color: Colors.redAccent,
              size: size,
            ),
            onPressed: () {
              favoritosCat = addProduto(favoritosCat, productId);

              favoritos[categoria] = favoritosCat;

              setFavoritos(favoritos);

              setState(() {
                atualizarFavoritos();
                isFavorito();
                atualizarFavoritosCat();
              });
            },
          );
  }

  void atualizarFavoritos() {
    favoritos = UserModel.of(context).userData['favoritos'];
  }

  void atualizarFavoritosCat() {
    if (UserModel.of(context).userData['favoritos'].isEmpty) {
      favoritosCat = List();
    } else {
      favoritosCat = UserModel.of(context).userData['favoritos'][categoria];
    }
  }

  void setFavoritos(Map fav) {
    Map<String, dynamic> userData = {
      "nome": UserModel.of(context).userData['nome'],
      "email": UserModel.of(context).userData['email'],
      "endereco": UserModel.of(context).userData['endereco'],
      "bairro": UserModel.of(context).userData['bairro'],
      "frete": UserModel.of(context).userData['frete'],
      "produtos": UserModel.of(context).userData['produtos'],
      "favoritos": fav,
    };
    UserModel.of(context).updateUserDate(userData);
  }

  void isFavorito() {
    if (UserModel.of(context).userData['favoritos'].isEmpty) {
      favorito = false;
    } else {
      favorito = UserModel.of(context).userData['favoritos'][categoria]
          .contains(productId);
    }
  }

  List removeProduto(List list, String id) {
    if (list.isEmpty) {
      return list;
    } else {
      List finalList = List();

      for (String l in list) {
        if (l != id) {
          finalList.add(l);
        }
      }

      return finalList;
    }
  }

  List addProduto(List list, String id) {
    List l = List();
    if (list.isEmpty) {
      l.add(id);
      return l;
    } else {
      List finalList = List();

      for (String l in list) {
        finalList.add(l);
      }

      finalList.add(id);

      return finalList;
    }
  }
}
