// lib/models/publicacao_model.dart
class Publicacao {
  final String dtPublicacao;
  final String descTipoPublicacao;
  final String descPublicacao;

  Publicacao({
    required this.dtPublicacao,
    required this.descTipoPublicacao,
    required this.descPublicacao,
  });

  factory Publicacao.fromJson(Map<String, dynamic> json) {
    return Publicacao(
      dtPublicacao: json['dtPublicacao'] ?? 'Não informado',
      descTipoPublicacao: json['descTipoPublicacao'] ?? '',
      descPublicacao: json['descPublicacao'] ?? '',
    );
  }
}