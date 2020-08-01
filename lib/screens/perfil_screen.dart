import 'package:flutter/material.dart';

import 'package:loja_virtual/tiles/perfil_tile.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meu Perfil"),
        ),
        body: PerfilTile(true));
  }
}
