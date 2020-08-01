import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/favoritos_screen.dart';
import 'package:loja_virtual/screens/produtos_categoria_screen.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/perfil_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget{
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return 
      PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title:Text("Atelier das Marias"),
                  centerTitle: true,
                ),
                body: _currentIndex == 0 ? HomeTab() : _currentIndex == 1 ? ProdutosCategoriaScreen(_pageController) : FavoritosScreen(_pageController),
                drawer: CustomDrawer(_pageController),
                floatingActionButton: CartButton(),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: onTabTapped,
                  currentIndex: _currentIndex,
                  items: [
                    ]BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      title: Text('Produtos'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      title: Text('Favoritos')
                    )
                  ],
                ),
              ),
          Scaffold(
            appBar: AppBar(
              title: Text("Meu Perfil"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: PerfilTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Lojas"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: PlacesTab(),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Meus Pedidos"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: OrdersTab(),
          ),
        ]);
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }

}
