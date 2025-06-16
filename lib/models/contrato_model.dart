// lib/contrato_model.dart

class Contrato {
  final String numContrato;         //
  final String numProcesso;         //
  final String numCpfCnpj;          //
  final String descForn;            //
  final String descObjeto;          //
  final String vlContrato;          //
  final String dtInicio;            //
  final String dtFim;               //
  final String dtAssinatura;        //
  final String dtPublicacao;        //
  final String nmModalidade;        //
  final String nmUnidade;           //

  Contrato({
    required this.numContrato,
    required this.numProcesso,
    required this.numCpfCnpj,
    required this.descForn,
    required this.descObjeto,
    required this.vlContrato,
    required this.dtInicio,
    required this.dtFim,
    required this.dtAssinatura,
    required this.dtPublicacao,
    required this.nmModalidade,
    required this.nmUnidade,
  });

  factory Contrato.fromJson(Map<String, dynamic> json) {
    return Contrato(
      numContrato: json['numContrato'] ?? 'Não informado',
      numProcesso: json['numProcesso'] ?? 'Não informado',
      numCpfCnpj: json['numCpfCnpj'] ?? 'Não informado',
      descForn: json['descForn'] ?? 'Não informado',
      descObjeto: json['descObjeto'] ?? 'Não informado',
      vlContrato: json['vlContrato'] ?? '0.00',
      dtInicio: json['dtInicio'] ?? 'Não informado',
      dtFim: json['dtFim'] ?? 'Não informado',
      dtAssinatura: json['dtAssinatura'] ?? 'Não informado',
      dtPublicacao: json['dtPublicacao'] ?? 'Não informado',
      nmModalidade: json['nmModalidade'] ?? 'Não informado',
      nmUnidade: json['nmUnidade'] ?? 'Não informado',
    );
  }
}