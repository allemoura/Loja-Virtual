import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/dados_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: ScopedModelDescendant<CartModel>(
            builder: (context, child, model){
              return ScopedModel<DadosModel>(
                model: DadosModel(),
                child: MaterialApp(
                  title: "Loja Virtual",
                  theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Color(0xFF7c631d)),
                  debugShowCheckedModeBanner: false,
                  home: HomeScreen())
              );
            })
        );
      }),
    );
  }
}
