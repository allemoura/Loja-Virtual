import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/perfil_screen.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cálcular Frete",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                UserModel.of(context).userData["bairro"],
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 60.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PerfilScreen()));
                },
                child: Text(
                  "modificar entrega",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
