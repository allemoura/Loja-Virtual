import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/cart_product.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/widgets/comentarios_card.dart';
import 'package:loja_virtual/widgets/favorito.dart';
import 'package:loja_virtual/widgets/star_display.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List avaliacoes;

  bool comprado;

  String size;
  String email;
  List produtosComprados;

  _ProductScreenState(this.product);

  @override
  void initState() {
    super.initState();

    email = UserModel.of(context).userData['email'];

    produtosComprados = UserModel.of(context).userData['produtos'];

    setComprado();

  }

  void setComprado(){
    if(UserModel.of(context).isLoggedIn()){
      comprado = produtosComprados.contains(product.id);
    }else{
      comprado = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.titulo),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        AspectRatio(
          aspectRatio: 0.75,
          child: Carousel(
            images: product.images.map((url) {
              return NetworkImage(url);
            }).toList(),
            dotSize: 4.0,
            dotSpacing: 15.0,
            dotBgColor: Colors.transparent,
            dotColor: primaryColor,
            //isso faz a img mudar automaticamente com true e autoplayDuration def o tempo de transicao
            autoplay: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 16.0, 0.0, 0.0),
          child: Text(
            product.titulo,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                comprado
                    ? RatingBar(
                        initialRating: product.avaliacao['avaliacao'] + 0.0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: comprado,
                        itemCount: 5,
                        itemPadding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        itemBuilder: (context, _) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                          );
                        },
                        onRatingUpdate: (rating) {
                          atualizaAvaliacoes(rating);
                        })
                    : StarDisplay(
                        starCount: 5,
                        rating: product.avaliacao['avaliacao'] + 0.0,
                        color: Colors.amber,
                        size: 45.0,
                      ),
                UserModel.of(context).isLoggedIn()
                    ? Favorito(product.id, 35.0, 75.0, product.categoria)
                    : Container(),
              ],
            )),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16.0),
                Text("Tamanho",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.tamanhos.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(
                                  color: s == size
                                      ? primaryColor
                                      : Colors.grey[500],
                                  width: 3.0,
                                )),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(s)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  key: _scaffoldKey,
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: size == null
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Widget okButton = FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'ok',
                                      style: TextStyle(color: Colors.white),
                                  ));
                                  return AlertDialog(
                                    content: Text(
                                      'Selecione um tamanho para adionar ao carrinho!!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: primaryColor,
                                    actions: [okButton],

                                  );
                                });
                          }
                        : () {
                            if (UserModel.of(context).isLoggedIn()) {
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = size;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.categoria;
                              cartProduct.productData = product;

                              CartModel.of(context).addCartItem(cartProduct);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          },
                    child: Text(
                      UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para Comprar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: size == null ? Colors.grey : primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.descricao,
                  style: TextStyle(fontSize: 16.0),
                ),
                ComentariosCard(product),
              ]),
        )
      ]),
    );
  }

  double somaAvaliacoes(List list) {
    int soma = 0;

    for (int l in list) {
      soma += l;
    }
    return soma + 0.0;
  }

  void atualizaAvaliacoes(double rating) {
    Map avaliacao = product.avaliacao['avaliacoes'];

    if (avaliacao.containsKey(email)) {
      avaliacao.update(email, (value) => rating.round());
    } else {
      avaliacao.putIfAbsent(email, () => rating.round());
    }
    product.avaliacao['avaliacoes'] = avaliacao;

    getAvaliacoes(avaliacao);

    product.avaliacao['qtd'] = avaliacoes.length;

    double soma = somaAvaliacoes(avaliacoes);

    product.avaliacao['avaliacao'] = soma / avaliacoes.length;

    atualizarAvaliacao();

    setState(() {});
  }

  atualizarAvaliacao() {
    Firestore.instance
        .collection('products')
        .document(product.categoria)
        .collection('items')
        .document(product.id)
        .updateData(product.productToMap());
  }

  getAvaliacoes(Map avaliacao) {
    List tmp = List();

    avaliacao.forEach((key, value) {
      tmp.add(value);
    });
    avaliacoes = tmp;
  }
}
