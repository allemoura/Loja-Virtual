import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/product_screen.dart';
import 'package:loja_virtual/widgets/favorito.dart';
import 'package:loja_virtual/widgets/star_display.dart';

class ProductTile extends StatelessWidget {
  final String tipo;
  final ProductData product;
  final double height;

  int qtdComentarios;

  ProductTile(this.tipo,this.height, this.product);

  @override
  Widget build(BuildContext context) {
    qtdComentarios = product.avaliacao['qtd'];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: tipo == 'grid'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.82,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(6.0, 8.0, 0.0, 4.0),
                    child: Text(product.titulo,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  )),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
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
                          )
                        ])),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(6.0, 7.0, 0.0, 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              product.promocao ?
                              Text(
                                'de R\$${product.preco.toStringAsFixed(2)} por',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              )
                              :Container(),
                              Text(
                                product.promocao ?
                                  "R\$${(product.preco - (product.preco * product.desconto)/100).toStringAsFixed(2)}"
                                  :
                                  "R\$${product.preco.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]
                          ) 
                        ),
                    ),
                    UserModel.of(context).isLoggedIn()
                        ? Favorito(product.id, 25.0, 0.0, product.categoria)
                        : Container(),
                  ])
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                      height: height,
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
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:<Widget>[
                                      product.promocao ?
                                      Text(
                                        'de R\$${product.preco.toStringAsFixed(2)} por',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      )
                                      :Container(),
                                      Text(
                                        product.promocao ?
                                          "R\$${(product.preco - (product.preco * product.desconto)/100).toStringAsFixed(2)}"
                                          :
                                          "R\$${product.preco.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]
                                  ),
                              ), 
                              UserModel.of(context).isLoggedIn()
                                  ? Favorito(
                                      product.id, 25.0, 10.0, product.categoria)
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
