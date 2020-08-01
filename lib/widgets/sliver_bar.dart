

import 'package:flutter/material.dart';

class SliverBar extends StatelessWidget{
  int _currentIndex;

  SliverBar(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
              floating:true,
              snap:true,
              backgroundColor: Theme.of(context).primaryColor, //Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_currentIndex == 0 ? "Novidade": _currentIndex == 1 ? "Produtos" : "Favoritos"),
                centerTitle:true
              ),
    );
  }

}