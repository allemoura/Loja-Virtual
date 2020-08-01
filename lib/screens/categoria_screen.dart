import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';

enum OrderOptions { ordermaior, ordermenor }

class CategoriaScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;

  CategoriaScreen(this.snapshot);

  @override
  _CategoriaScreenState createState() => _CategoriaScreenState(snapshot);
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  final DocumentSnapshot snapshot;

  List<ProductData> produtos = List();

  _CategoriaScreenState(this.snapshot);

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data['title']),
              centerTitle: true,
              bottom: TabBar(indicatorColor: Colors.white, tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                ),
              ]),
              actions: [
                PopupMenuButton<OrderOptions>(
                  icon: Icon(Icons.filter_list),
                  itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                    const PopupMenuItem<OrderOptions>(
                      child: Text("Ordenar Pelo Maior Preço"),
                      value: OrderOptions.ordermaior,
                    ),
                    const PopupMenuItem<OrderOptions>(
                      child: Text("Ordenar Pelo Menor Preço"),
                      value: OrderOptions.ordermenor,
                    ),
                  ],
                  onSelected: _orderList,
                )
              ],
            ),
            body:
                TabBarView(physics: NeverScrollableScrollPhysics(), children: [
              GridView.builder(
                padding: EdgeInsets.all(4.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.48,
                ),
                itemCount: produtos.length,
                itemBuilder: (context, int index) {
                  ProductData data = produtos[index];
                  data.categoria = this.snapshot.documentID;
                  return ProductTile('grid',0.0, data);
                },
              ),
              ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    ProductData data = produtos[index];
                    data.categoria = this.snapshot.documentID;
                    return ProductTile('list',220.0, data);
                  })
            ])));
  }

  void getProducts() async {
    List<ProductData> p = List();
    await Firestore.instance
        .collection('products')
        .document(snapshot.documentID)
        .collection('items')
        .getDocuments()
        .then(
          (value) {
            int i = 0;
            while (i < value.documents.length) {
              ProductData data = ProductData.fromDocument(value.documents[i]);
              p.add(data);
              i++;
            }
    });
    setState(() {
      produtos = p;
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.ordermenor:
        produtos.sort((a, b) {
          return a.preco.compareTo(b.preco);
        });
        break;
      case OrderOptions.ordermaior:
        produtos.sort((a, b) {
          return b.preco.compareTo(a.preco);
        });
        break;
    }
    setState(() {});
  }
}
