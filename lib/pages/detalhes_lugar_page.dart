import 'package:flutter/material.dart';

import '../model/lugar.dart';

class DetalhesLugarPage extends StatelessWidget {
  final Lugar lugar;

  const DetalhesLugarPage({Key? key, required this.lugar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Lugar'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[300]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset('images/a_image_segundaTela.png', height: 100, width: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoTile(Icons.location_on, 'Nome', lugar.nome),
                      _infoTile(Icons.description, 'Descrição', lugar.descricao),
                      _infoTile(Icons.place, 'Localização', lugar.localizacao ?? 'Não informado'),
                      _infoTile(Icons.date_range, 'Data da Visita', lugar.dataVisitaFormatada),
                      if (lugar.atividadesRealizadas != null && lugar.atividadesRealizadas!.isNotEmpty)
                        _infoTile(Icons.checklist_rounded, 'Atividades', lugar.atividadesRealizadas!.join(', ')),
                      _infoTile(Icons.confirmation_number, 'Código', lugar.id.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 26), // Azul mais escuro para os ícones
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
