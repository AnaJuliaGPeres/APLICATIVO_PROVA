// lib/services/cep_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cep.dart'; // Importe o modelo Cep

class CepApiService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  Future<Cep?> fetchCep(String cep) async {
    // Remove caracteres não numéricos do CEP
    final String cepNumerico = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepNumerico.length != 8) {
      print('CEP inválido: $cepNumerico');
      return null; // Ou lançar uma exceção específica
    }

    final String url = '$_baseUrl/$cepNumerico/json/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        // A API ViaCEP retorna um erro { "erro": true } para CEPs não encontrados
        if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('erro') && decodedBody['erro'] == true) {
          print('CEP não encontrado: $cepNumerico');
          return null;
        }
        return Cep.fromJson(decodedBody);
      } else {
        print('Erro ao buscar CEP: ${response.statusCode}');
        return null; // Ou lançar uma exceção
      }
    } catch (e) {
      print('Erro na requisição do CEP: $e');
      return null; // Ou lançar uma exceção
    }
  }
}