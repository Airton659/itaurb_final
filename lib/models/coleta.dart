class Coleta {
  final String dia;
  final String horario;

  Coleta({required this.dia, required this.horario});

  factory Coleta.fromJson(Map<String, dynamic> json) {
    return Coleta(
      dia: json['dia'],
      horario: json['horario'],
    );
  }

  Map<String, dynamic> toJson() => {
        'dia': dia,
        'horario': horario,
      };
}