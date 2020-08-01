import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

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

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  Bairros _bairros;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();

  String bairro;
  double frete;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Cadastrar"),
          centerTitle: true,
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoding) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@") || text.length < 4)
                      return "E-mail inválido!";
                  },
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 8)
                      return "Senha inválida!";
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _enderecoController,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                  validator: (text) {
                    if (text.isEmpty) return "Endereço inválido!";
                  },
                ),
                SizedBox(height: 16.0),
                _bairroCard(context),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      "Criar Conta",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          _bairros != null) {
                        Map<String, dynamic> userData = {
                          "nome": _nameController.text,
                          "email": _emailController.text,
                          "endereco": _enderecoController.text,
                          "bairro": bairro,
                          "frete": frete,
                          "produtos": [],
                          "favoritos": {
                            "vestidos" : [],
                            "calcas" : [],
                            "blusas" : [],
                            "camisetas": []
                          },
                        };

                        model.signUp(
                            userData: userData,
                            pass: _senhaController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      } else if (_bairros == null) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              "Por favor, selecione um bairro para concluir!!"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                  ),
                ),
              ]));
        }));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 3),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário !!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
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
              if (snapshot.connectionState == ConnectionState.waiting &&
                  _bairros == null) {
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
