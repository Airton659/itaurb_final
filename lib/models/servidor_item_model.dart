// lib/models/servidor_item_model.dart

class ServidorItem {
  final String descCodigo;
  final String descEvento;
  final String descTipo; // "P" para Provento, "D" para Desconto
  final String descRefe;
  final String numValor;

  ServidorItem({
    required this.descCodigo,
    required this.descEvento,
    required this.descTipo,
    required this.descRefe,
    required this.numValor,
  });

  factory ServidorItem.fromJson(Map<String, dynamic> json) {
    return ServidorItem(
      descCodigo: json['descCodigo'] ?? '',
      descEvento: json['descEvento'] ?? '',
      descTipo: json['descTipo'] ?? '',
      descRefe: json['descRefe'] ?? '',
      numValor: json['numValor'] ?? '0',
    );
  }
}