import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';
import 'package:loja_virtual/widgets/favorito.dart';
import 'package:loja_virtual/widgets/star_display.dart';

class FavoritosTile extends StatelessWidget {
  final ProductData product;

  FavoritosTile(this.product);

  int qtdComentarios;

  @override
  Widget build(BuildContext context) {
    qtdComentarios = product.avaliacao['qtd'];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Flexible(
                flex: 1,
                child: Image.network(
                  product.images[0],
                  fit: BoxFit.cover,
                  height: 180.0,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.titulo,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(children: <Widget>[
                              StarDisplay(
                                starCount: 5,
                                rating: product.avaliacao['avaliacao'] + 0.0,
                                color: Colors.amber,
                                size: 17.0,
                              ),
                              Text(
                                "(${qtdComentarios})",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                              ),
                            ])),
                        Padding(
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      product.promocao
                                          ? Text(
                                              'de R\$${product.preco.toStringAsFixed(2)} por',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : Container(),
                                      Text(
                                        product.promocao
                                            ? "R\$${(product.preco - (product.preco * product.desconto) / 100).toStringAsFixed(2)}"
                                            : "R\$${product.preco.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                Favorito(
                                    product.id, 25.0, 10.0, product.categoria)
                              ],
                            ))
                      ]),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
