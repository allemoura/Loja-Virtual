
import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/favoritos_tab.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class FavoritosScreen extends StatelessWidget{
  final _pageController;

  FavoritosScreen(this._pageController);
  
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        drawer: CustomDrawer(_pageController),
        body: FavoritosTab(1),
      );
  }

}