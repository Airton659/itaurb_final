// lib/utils/formatters.dart
import 'package:intl/intl.dart';

String formatarMoeda(String? valorString) {
  // Se o valor for nulo ou vazio, retorna um padrão.
  if (valorString == null || valorString.isEmpty) {
    return 'R\$ 0,00';
  }

  try {
    // 1. Converte a string recebida (ex: "197064.00") em um número.
    final double valorNumerico = double.parse(valorString);

    // 2. Cria um formatador de moeda para o padrão brasileiro (pt_BR).
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    // 3. Usa o formatador para transformar o número na string desejada (ex: "R$ 197.064,00")
    return formatador.format(valorNumerico);
  } catch (e) {
    // Caso a string não seja um número válido, retorna o próprio valor.
    return valorString;
  }
}