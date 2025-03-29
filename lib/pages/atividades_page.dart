import 'package:flutter/material.dart';

class AtividadesPage extends StatefulWidget {
  @override
  _AtividadesPageState createState() => _AtividadesPageState();
}

class _AtividadesPageState extends State<AtividadesPage> {
  List<String> atividades = [
    'Cafeteira', 'Lazer', 'Restaurante', 'Academia', 'Parque', 'Para Crianças'
  ];

  List<String> atividadesSelecionadas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecione as Atividades')),
      body: ListView(
        children: atividades.map((atividade) {
          return CheckboxListTile(
            title: Text(atividade),
            value: atividadesSelecionadas.contains(atividade),
            onChanged: (bool? selected) {
              setState(() {
                if (selected != null && selected) {
                  atividadesSelecionadas.add(atividade);
                } else {
                  atividadesSelecionadas.remove(atividade);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Retorna as atividades selecionadas para a página anterior
          Navigator.pop(context, atividadesSelecionadas.join(', '));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
