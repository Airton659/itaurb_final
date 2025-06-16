// lib/models/processo_seletivo_model.dart
import 'publicacao_model.dart';

class ProcessoSeletivo {
  final String numExercicio;
  final String numProcesso;
  final String descNome;
  final String descSituacao;
  final List<Publicacao> publicacoes;

  ProcessoSeletivo({
    required this.numExercicio,
    required this.numProcesso,
    required this.descNome,
    required this.descSituacao,
    required this.publicacoes,
  });

  factory ProcessoSeletivo.fromJson(Map<String, dynamic> json) {
    var listaPublicacoesJson = json['publicacao'] as List? ?? [];
    List<Publicacao> listaPublicacoes = listaPublicacoesJson.map((p) => Publicacao.fromJson(p)).toList();

    return ProcessoSeletivo(
      numExercicio: json['numExercicio'] ?? '',
      numProcesso: json['numProcesso'] ?? '',
      descNome: json['descNome'] ?? 'Nome não informado',
      descSituacao: json['descSituacao'] ?? 'Situação não informada',
      publicacoes: listaPublicacoes,
    );
  }
}