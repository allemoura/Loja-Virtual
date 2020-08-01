import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

enum Bairros {
  altomedeiros,
  arnaldolafaiety,
  barra,
  belavista,
  centro,
  inaciaemidiadiniz,
  piabao,
  none
}

class PerfilTile extends StatefulWidget {
  final bool carrinho;

  PerfilTile(this.carrinho);

  @override
  _PerfilTileState createState() => _PerfilTileState(carrinho);
}

class _PerfilTileState extends State<PerfilTile> {
  final bool carrinho;

  _PerfilTileState(this.carrinho);

  Bairros _bairros;
  bool iniciado = false;

  final _nameController = TextEditingController();
  final _enderecoController = TextEditingController();

  String bairro;
  double frete;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _bairros = getBairro(UserModel.of(context).userData['bairro']);
      bairro = UserModel.of(context).userData['bairro'];
      iniciado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = UserModel.of(context).userData['nome'];
    _enderecoController.text = UserModel.of(context).userData['endereco'];
    return Form(
        key: _formKey,
        child: ListView(padding: EdgeInsets.all(16.0), children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "Nome Completo",
            ),
            validator: (text) {
              if (text.isEmpty) return "Nome inválido!";
            },
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _enderecoController,
            decoration: InputDecoration(
              hintText: "Seu Endereço",
            ),
            validator: (text) {
              if (text.isEmpty) return "Nome inválido!";
            },
          ),
          SizedBox(height: 16.0),
          _bairroCard(context),
          SizedBox(height: 16.0),
          SizedBox(
            height: 44.0,
            child: RaisedButton(
              child: Text(
                "Alterar Cadastro",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (_nameController.text !=
                          UserModel.of(context).userData['nome'] ||
                      _enderecoController.text !=
                          UserModel.of(context).userData['endereco'] ||
                      bairro != UserModel.of(context).userData['bairro']) {
                    Map<String, dynamic> userData = {
                      "nome": _nameController.text,
                      "email": UserModel.of(context).userData['email'],
                      "endereco": _enderecoController.text,
                      "bairro": bairro,
                      "frete": frete,
                      "produtos": UserModel.of(context).userData['produtos'],
                      "favoritos": UserModel.of(context).userData['favoritos'],
                    };
                    UserModel.of(context).updateUser(
                        onFail: onFail,
                        onSuccess: onSuccess,
                        userData: userData);
                  } else {
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

                          AlertDialog alert = AlertDialog(
                            content: Text(
                              'Modifique seus dados!!',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            actions: [
                              okButton,
                            ],
                          );

                          return alert;
                        });
                  }
                }
              },
            ),
          ),
        ]));
  }

  void onSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          Widget okButton = FlatButton(
              onPressed: () {
                carrinho
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => CartScreen()))
                    : Navigator.of(context).pop();
              },
              child: Text(
                'ok',
                style: TextStyle(color: Colors.white),
              ));

          AlertDialog alert = AlertDialog(
            content: Text(
              'Usuário atualizado com sucesso!!',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              okButton,
            ],
          );

          return alert;
        });
  }

  void onFail() {
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

          AlertDialog alert = AlertDialog(
            content: Text(
              'Falha ao atualizar usuário, tente novamente!!',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              okButton,
            ],
          );

          return alert;
        });
  }

  Widget _bairroCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Selecione seu Bairro",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.location_searching),
        trailing: Icon(Icons.navigate_next),
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0), child: _bairroTile(context))
        ],
      ),
    );
  }

  Widget _bairroTile(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: FutureBuilder(
            future: getBairros(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]['title']),
                        leading: Radio(
                            value: getBairro(snapshot.data[index]['title']),
                            groupValue: _bairros,
                            onChanged: (value) {
                              setState(() {
                                _bairros = value;
                                bairro = snapshot.data[index]['title'];
                                frete = snapshot.data[index]['frete'] + 0.0;
                              });
                            }),
                      );
                    });
              }
            }),
      ),
    ]);
  }

  Future getBairros() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection("bairro").getDocuments();
    return qn.documents;
  }

  dynamic getBairro(String value) {
    if (value == "Alto Medeiros") {
      return Bairros.altomedeiros;
    } else if (value == "Arnaldo Lafaiety") {
      return Bairros.arnaldolafaiety;
    } else if (value == "Barra") {
      return Bairros.barra;
    } else if (value == "Bela Vista") {
      return Bairros.belavista;
    } else if (value == "Centro") {
      return Bairros.centro;
    } else if (value == "Inácia Emidia Diniz") {
      return Bairros.inaciaemidiadiniz;
    } else if (value == "Piabão") {
      return Bairros.piabao;
    } else {
      return Bairros.none;
    }
  }
}
