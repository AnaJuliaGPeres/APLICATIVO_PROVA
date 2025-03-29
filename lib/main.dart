import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/lista_lugares.dart';
import 'pages/tela_inicial.dart';
import 'model/lugar.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diário de Lugares',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define a TelaInicial como a primeira tela
      home: TelaInicial(),
      onGenerateRoute: (settings) {
        if (settings.name == '/lista_lugares') {
          final List<Lugar> lugares = settings.arguments as List<Lugar>;
          return MaterialPageRoute(
            builder: (context) => ListaLugaresPage(lugares: lugares),
          );
        }
        return null; // Retorna nulo se a rota não for encontrada
      },
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}
