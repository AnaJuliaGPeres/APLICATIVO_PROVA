// lib/model/cep.dart
import 'package:json_annotation/json_annotation.dart';

part 'cep.g.dart';

@JsonSerializable()
class Cep {
  final String? cep;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String? localidade; // Cidade
  final String? uf; // Estado
  final String? ibge;
  final String? gia;
  @JsonKey(name: 'ddd')
  final String? ddd; // Ajustado para corresponder ao exemplo, pode ser codiArea se preferir
  final String? siafi;

  Cep({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
  });

  factory Cep.fromJson(Map<String, dynamic> json) => _$CepFromJson(json);
  Map<String, dynamic> toJson() => _$CepToJson(this);


  String get enderecoFormatado {
    List<String> parts = [];
    if (logradouro != null && logradouro!.isNotEmpty) parts.add(logradouro!);
    if (bairro != null && bairro!.isNotEmpty) parts.add(bairro!);
    if (localidade != null && localidade!.isNotEmpty) parts.add(localidade!);
    if (uf != null && uf!.isNotEmpty) parts.add(uf!);
    return parts.join(', ');
  }
}