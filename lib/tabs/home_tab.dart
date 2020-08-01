
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';

class HomeTab extends StatefulWidget{
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin{  
  TabController _tabController;

  List<ProductData> produtosPromocao = List();
  List categorias = List();
  List<ProductData> produtosMaisVendidos = List();


  @override
  void initState() {
    super.initState();
    categorias = ['blusas', 'calsas', 'camisetas', 'vestidos'];
    _setDados();
    _tabController = TabController(
      length: 2, 
      vsync:this,
    );
  }

  _setDados() async{
    await Firestore.instance.collection('controler').document("data").get().then((value) => categorias = value.data['categorias']);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _setProdutos();
    });
    return
      Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Firestore.instance.collection('banner').orderBy('pos').getDocuments(),
              builder: (context, snapshot){
                
                if(!snapshot.hasData){
                  return Container(
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor:AlwaysStoppedAnimation<Color>(Colors.white)
                    ),
                  );
                }else{
                  return
                    AspectRatio(
                      aspectRatio: 2.2,
                      child: Carousel(
                        images: snapshot.data.documents
                          .map((doc) => NetworkImage(doc.data['image']))
                            .toList(),
                        dotSize: 4.0,
                        dotSpacing: 15.0,                        
                        dotBgColor: Colors.transparent,
                        dotColor: Theme.of(context).primaryColor,
                        autoplay: true,
                        autoplayDuration: Duration(seconds: 5),
                      ),
                    );
                  }
              }
            ),
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  text: 'Promoção',
                ),
                Tab(
                  text: 'Mais Vendidos',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Center(
                    child: 
                      ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: produtosPromocao.length,
                        itemBuilder: (context,index){
                          ProductData data = produtosPromocao[index];
                           return ProductTile('list', 100.0, data);
                        }
                      )
                  ),
                  Center(
                    child:
                      ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: produtosMaisVendidos.length,
                        itemBuilder: (context,index){
                          ProductData data = produtosMaisVendidos[index];
                           return ProductTile('list', 100.0, data);
                        }
                      ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }

  _setProdutos() async {
    List<ProductData> p = List();
    List<ProductData> p2 = List();
    
    for (String c in categorias) {
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
    
    setState(() {
      produtosMaisVendidos = p;
      produtosPromocao = p2;
    });
    
    
  }

  _ordenaMaisVendidos(List produtos){
    produtos.sort((a,b){
      return b.vendido.compareTo(a.vendido); 
    });
    return produtos;   
  }
}