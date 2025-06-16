// lib/legislacao_model.dart

class Legislacao {
  final String numExercicio;      //
  final String numLegislacao;     //
  final String dtLegislacao;      //
  final String dtAssinatura;      //
  final String descAssunto;       //
  final String descResumo;        //
  final bool stRevogada;          //

  Legislacao({
    required this.numExercicio,
    required this.numLegislacao,
    required this.dtLegislacao,
    required this.dtAssinatura,
    required this.descAssunto,
    required this.descResumo,
    required this.stRevogada,
  });

  factory Legislacao.fromJson(Map<String, dynamic> json) {
    return Legislacao(
      numExercicio: json['numExercicio'] ?? 'N/A',
      numLegislacao: json['numLegislacao'] ?? 'N/A',
      dtLegislacao: json['dtLegislacao'] ?? 'Não informado',
      dtAssinatura: json['dtAssinatura'] ?? 'Não informado',
      descAssunto: json['descAssunto'] ?? 'Não informado',
      descResumo: json['descResumo'] ?? 'Não informado',
      // Converte a string "True"/"False" para um booleano
      stRevogada: json['stRevogada']?.toString().toLowerCase() == 'true',
    );
  }
}