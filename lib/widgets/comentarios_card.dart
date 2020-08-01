import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/data/products_data.dart';
import 'package:loja_virtual/models/user_model.dart';

class ComentariosCard extends StatefulWidget {
  ProductData product;

  ComentariosCard(this.product);

  @override
  _ComentariosCardState createState() => _ComentariosCardState(product);
}

class _ComentariosCardState extends State<ComentariosCard> {
  ProductData product;

  final _comentarioController = TextEditingController();

  bool _enabled = false;
  String comentario;
  String usuarioNome;
  String usuarioEmail;

  List<List<String>> infos = List();
  List<List<String>> comentarios = List();

  _ComentariosCardState(this.product);

  @override
  void initState() {
    super.initState();
    //getComentarios();
    setUsuario();
    comentario = "";
    verificaProdutoComprado();
  }

  void verificaProdutoComprado() {
    if (UserModel.of(context).isLoggedIn()) {
      if (UserModel.of(context).userData['produtos'].contains(product.id)) {
        _enabled = true;
      } else {
        _enabled = false;
      }
    }
  }

  setUsuario(){
    if(UserModel.of(context).isLoggedIn()){
      usuarioNome = UserModel.of(context).userData['nome'];
      usuarioEmail = UserModel.of(context).userData['email'];
    }else{
      usuarioEmail = "defautTesteTeste";
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getComentarios();
    });
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 16.0),
      child: ExpansionTile(
        title: Text(
          "Comentarios",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.comment),
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FocusScope(
                    child: TextFormField(
                      enabled: _enabled,
                      controller: _comentarioController,
                      decoration: InputDecoration(
                          hintText: _enabled
                              ? "Faça um comentário..."
                              : "Compre para avaliar.."),
                      toolbarOptions: ToolbarOptions(
                        copy: true,
                        cut: true,
                        paste: true,
                      ),
                      keyboardType: TextInputType.multiline,
                      onChanged: (text) {
                        setState(() {
                          comentario = text;
                        });
                      },
                    ),
                  )),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 19.0, 8.0, 0.0),
                child: SizedBox(
                  height: 30.0,
                  child: RaisedButton(
                      child: Text('comentar'),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (!comentario.isEmpty) {
                          String id = usuarioEmail +
                              " " +
                              comentarios.length.toString();
                          String c =
                              "comentario" + comentarios.length.toString();
                          product.comentarios
                              .addAll({id: usuarioNome, c: comentario});
                          atualizaComentarios();
                          _comentarioController.text = "";
                          comentario = "";
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
                                    'Digite seu comentário!!',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  actions: [
                                    okButton,
                                  ],
                                );

                                return alert;
                              });
                        }
                      }),
                ))
          ]),
          comentarios.isEmpty
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  color: Colors.grey[50],
                  child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Esse produto não tem comentários...',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic),
                      )))
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: comentarios.length,
                  itemBuilder: (context, int index) {
                    bool mine = infos[index][0].contains(usuarioEmail);

                    return Column(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5.0),
                          color: Colors.grey[50],
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        comentarios[index][0],
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        comentarios[index][1],
                                        style: TextStyle(
                                          color: Colors.grey[30],
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ),
                                  ])),
                              mine
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 25.5, 5.0, 0.0),
                                      child: GestureDetector(
                                        child: Icon(Icons.delete),
                                        onTap: () {
                                          deleteComentario(index);
                                        },
                                      ))
                                  : Container()
                            ],
                          )),
                    ]);
                  },
                )
        ],
      ),
    );
  }

  getComentarios() {
    List<List<String>> tmp = List();
    List<List<String>> tmp1 = List();
    List<List<String>> inf = List();

    product.comentarios.forEach((key, value) {
      List<String> tmp2 = List();
      tmp2.add(key);
      tmp2.add(value);

      tmp.add(tmp2);
    });
    int i = 0;
    int j = 1;

    while (j < tmp.length) {
      List<String> tmp2 = List();
      List<String> tmp3 = List();

      tmp2.add(tmp[i][1]);
      tmp2.add(tmp[j][1]);

      tmp3.add(tmp[i][0]);
      tmp3.add(tmp[j][0]);

      inf.add(tmp3);

      tmp1.add(tmp2);
      i += 2;
      j += 2;
    }
    setState(() {
      comentarios = tmp1;
      infos = inf;
    });
  }

  deleteComentario(int index) {
    product.comentarios.remove(infos[index][0]);
    product.comentarios.remove(infos[index][1]);

    atualizaComentarios();
  }

  atualizaComentarios() {
    Firestore.instance
        .collection('products')
        .document(product.categoria)
        .collection('items')
        .document(product.id)
        .setData(product.productToMap());

    setState(() {
      getComentarios();
    });
  }
}
