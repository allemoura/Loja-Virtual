import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              snapshot.data["image"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data["title"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
                ),
                Text(
                  snapshot.data["endereco"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Image.network(
                  "https://cdn.icon-icons.com/icons2/1582/PNG/512/whatsapp_108042.png",
                  width: 30.0,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  launch(snapshot.data["whatsapp"], forceSafariVC: false);
                },
              ),
              FlatButton(
                child: Image.network(
                  "https://cdn.icon-icons.com/icons2/1582/PNG/512/facebook_108044.png",
                  width: 30.0,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  launch(snapshot.data["facebook"], forceSafariVC: false);
                },
              ),
              FlatButton(
                child: Image.network(
                  "https://cdn.icon-icons.com/icons2/1582/PNG/512/instagram_108043.png",
                  width: 30.0,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  launch(snapshot.data["facebook"], forceSafariVC: false);
                },
              ),
              Expanded(
                child: FlatButton(
                  child: Text("Ligar"),
                  textColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    launch("tel:${snapshot.data["phone"]}");
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
