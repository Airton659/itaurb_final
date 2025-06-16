// lib/models/servidor_model.dart
import 'servidor_item_model.dart';

class Servidor {
  final String numMatricula;
  final String descServidor;
  final String descFuncao;
  final String dtCompetencia;
  final String vlProvento;
  final String vlDesconto;
  final String vlLiquido;
  final List<ServidorItem> itens; // Lista de itens do holerite

  Servidor({
    required this.numMatricula,
    required this.descServidor,
    required this.descFuncao,
    required this.dtCompetencia,
    required this.vlProvento,
    required this.vlDesconto,
    required this.vlLiquido,
    required this.itens,
  });

  factory Servidor.fromJson(Map<String, dynamic> json) {
    // Converte a lista de JSONs de itens para uma lista de objetos ServidorItem
    var listaItensJson = json['itens'] as List? ?? [];
    List<ServidorItem> listaItens = listaItensJson.map((i) => ServidorItem.fromJson(i)).toList();

    return Servidor(
      numMatricula: json['numMatricula'] ?? '',
      descServidor: json['descServidor'] ?? 'Nome não informado',
      descFuncao: json['descFuncao'] ?? 'Função não informada',
      dtCompetencia: json['dtCompetencia'] ?? '',
      vlProvento: json['vlProvento'] ?? '0.00',
      vlDesconto: json['vlDesconto'] ?? '0.00',
      vlLiquido: json['vlLiquido'] ?? '0.00',
      itens: listaItens,
    );
  }
}