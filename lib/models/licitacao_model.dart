// lib/licitacao_model.dart

class Licitacao {
  // Campos existentes
  final String numLicitacao;
  final String descModalidade;
  final String descObjeto;
  final String dtPublicacao;
  final String status;

  // --- NOVOS CAMPOS ADICIONADOS ---
  final String numAno;            //
  final String descUnidade;       //
  final String numProcesso;       //
  final String dtHabilitacao;     //
  final String hrHabilitacao;     //
  final String dtLimite;          //
  final String nuValorEstimado;   //

  Licitacao({
    // Campos existentes
    required this.numLicitacao,
    required this.descModalidade,
    required this.descObjeto,
    required this.dtPublicacao,
    required this.status,
    // --- NOVOS CAMPOS ADICIONADOS ---
    required this.numAno,
    required this.descUnidade,
    required this.numProcesso,
    required this.dtHabilitacao,
    required this.hrHabilitacao,
    required this.dtLimite,
    required this.nuValorEstimado,
  });

  factory Licitacao.fromJson(Map<String, dynamic> json) {
    return Licitacao(
      // Campos existentes
      numLicitacao: json['numLicitacao']?.toString() ?? 'N/A',
      descModalidade: json['descModalidade'] ?? 'Não informado',
      descObjeto: json['descObjeto'] ?? 'Objeto não descrito',
      dtPublicacao: json['dtPublicacao'] ?? 'Data não informada',
      status: json['dmStatus'] ?? 'Status não informado',

      // --- NOVOS CAMPOS ADICIONADOS ---
      // Mapeando os novos campos do JSON para o nosso objeto
      numAno: json['numAno']?.toString() ?? 'N/A',
      descUnidade: json['descUnidade'] ?? 'Não informada',
      numProcesso: json['numProcesso'] ?? 'Não informado',
      dtHabilitacao: json['dtHabilitacao'] ?? 'Não informada',
      hrHabilitacao: json['hrHabilitacao'] ?? 'Não informada',
      dtLimite: json['dtLimite'] ?? 'Não informada',
      nuValorEstimado: json['nuValorEstimado']?.toString() ?? 'Não informado',
    );
  }
}