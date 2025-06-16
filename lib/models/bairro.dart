import 'coleta.dart';

class Bairro {
  final String nome;
  final Map<String, List<Coleta>> coletas;
  bool favorito;

  Bairro({
    required this.nome,
    required this.coletas,
    this.favorito = false,
  });

  factory Bairro.fromJson(String nome, Map<String, dynamic> json) {
    Map<String, List<Coleta>> coletas = {};
    
    json.forEach((tipoColeta, listaColetas) {
      coletas[tipoColeta] = (listaColetas as List)
          .map((coleta) => Coleta.fromJson(coleta))
          .toList();
    });

    return Bairro(
      nome: nome,
      coletas: coletas,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> coletasJson = {};
    
    coletas.forEach((tipoColeta, listaColetas) {
      coletasJson[tipoColeta] = listaColetas.map((coleta) => coleta.toJson()).toList();
    });

    return {
      'nome': nome,
      'coletas': coletasJson,
      'favorito': favorito,
    };
  }
}