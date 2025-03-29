import 'package:flutter/material.dart';
import 'adicionar_lugar_page.dart'; // Página de adicionar lugares
import 'lista_lugares.dart';
import '../model/lugar.dart'; // Importa o modelo de Lugar

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Lugar> _lugares = []; // Lista para armazenar os lugares cadastrados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _criarCabecalho(),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.blue[50],
              ),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildSquareButton(
                    context: context,
                    text: 'Cadastrar Lugar',
                    icon: Icons.add_location_alt,
                    onPressed: () async {
                      final novoLugar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdicionarLugarPage(),
                        ),
                      );
                      if (novoLugar != null) {
                        setState(() {
                          _lugares.add(novoLugar); // Adiciona o novo lugar à lista
                        });
                      }
                    },
                  ),
                  _buildSquareButton(
                    context: context,
                    text: 'Visualizar e Editar Lugares',
                    icon: Icons.location_on,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaLugaresPage(lugares: _lugares),
                        ),
                      ).then((_) {
                        setState(() {}); // Atualiza a tela ao voltar
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _criarCabecalho() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[300]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Image.asset('images/a_image_segundaTela.png', height: 100, width: 100),
          Text(
            'JourneyMap',
            style: TextStyle(fontSize: 32, fontFamily: 'FonteUsada', fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            'Bem-vindo(a)!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'FonteUsada', color: Colors.blue[900]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '📍 "Cadastrar Lugar" para adicionar novos locais.\n'
                  '📖 "Visualizar e Editar Lugares" para ver e modificar suas viagens.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSquareButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(2, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue[700]),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}