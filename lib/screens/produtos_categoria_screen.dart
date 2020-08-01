import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class ProdutosCategoriaScreen extends StatelessWidget{
  final _pageController;
  ProdutosCategoriaScreen(this._pageController);
  
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        drawer: CustomDrawer(_pageController),
        body: ProductsTab(),
    );
  }
}
