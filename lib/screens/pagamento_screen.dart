import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

enum SingingCharacter { dinheiro, credito, debito }

class PagamentoScreen extends StatefulWidget {
  final VoidCallback buy;
  final CartModel model;

  PagamentoScreen(this.buy, this.model);

  @override
  _PagamentoScreenState createState() => _PagamentoScreenState(buy, model);
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  final VoidCallback buy;
  final CartModel model;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SingingCharacter _character;

  _PagamentoScreenState(this.buy, this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Pagamento"),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          ListTile(
            title: const Text("Dinheiro"),
            leading: Radio(
                value: SingingCharacter.dinheiro,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    model.setPagamento("Dinheiro");
                  });
                }),
          ),
          ListTile(
            title: const Text("Cartão de Crédito"),
            leading: Radio(
                value: SingingCharacter.credito,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    model.setPagamento("Cartão de Crédito");
                  });
                }),
          ),
          ListTile(
            title: const Text("Cartão de Débito"),
            leading: Radio(
                value: SingingCharacter.debito,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                    model.setPagamento("Cartão de Débito");
                  });
                }),
          ),
          RaisedButton(
            child: Text("Finalizar Pedido"),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_character == null) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Selecione uma forma de pagamento!!"),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 3),
                ));
              } else {
                List a =
                    model.user.userData['produtos'] + model.getIdProducts();
                print(a);
                Map<String, dynamic> userData = {
                  "nome": model.user.userData['nome'],
                  "email": model.user.userData['email'],
                  "endereco": model.user.userData['endereco'],
                  "bairro": model.user.userData['bairro'],
                  "frete": model.user.userData['frete'],
                  "produtos": a,
                  "favoritos":model.user.userData['favoritos'],
                };
                model.user.updateUserDate(userData);

                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("O pagamento será feito na entrega!!"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 3),
                ));
                buy();
              }
            },
          )
        ]));
  }
}
