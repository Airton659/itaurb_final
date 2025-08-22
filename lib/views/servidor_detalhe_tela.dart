// lib/telas/servidor_detalhe_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/services/formatters.dart';
import '../models/servidor_model.dart';

class ServidorDetalheTela extends StatelessWidget {
  final Servidor servidor;
  const ServidorDetalheTela({super.key, required this.servidor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(servidor.descServidor), backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetalheRow(context, 'Matrícula:', servidor.numMatricula),
                  _buildDetalheRow(context, 'Função:', servidor.descFuncao),
                  _buildDetalheRow(context, 'Competência:', servidor.dtCompetencia),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Card com o resumo financeiro
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDetalheRow(context, 'Total de Proventos:', formatarMoeda(servidor.vlProvento), cor: Colors.blue),
                  _buildDetalheRow(context, 'Total de Descontos:', formatarMoeda(servidor.vlDesconto), cor: Colors.red),
                  const Divider(height: 24),
                  _buildDetalheRow(context, 'Valor Líquido:', formatarMoeda(servidor.vlLiquido), cor: Colors.green, isBold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Card com a lista de itens do holerite
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detalhamento da Folha', style: Theme.of(context).textTheme.titleLarge),
                  const Divider(),
                  Table(
                    columnWidths: const { 0: FlexColumnWidth(3), 1: FlexColumnWidth(1.5), 2: FlexColumnWidth(1.5)},
                    border: TableBorder.all(color: Colors.grey.shade200, width: 1),
                    children: [
                       const TableRow(
                         decoration: BoxDecoration(color: Colors.black12),
                         children: [
                           Padding(padding: EdgeInsets.all(8.0), child: Text('Evento', style: TextStyle(fontWeight: FontWeight.bold))),
                           Padding(padding: EdgeInsets.all(8.0), child: Text('Referência', style: TextStyle(fontWeight: FontWeight.bold))),
                           Padding(padding: EdgeInsets.all(8.0), child: Text('Valor', style: TextStyle(fontWeight: FontWeight.bold))),
                         ],
                       ),
                       ...servidor.itens.map((item) => TableRow(
                         children: [
                           Padding(padding: const EdgeInsets.all(8.0), child: Text(item.descEvento)),
                           Padding(padding: const EdgeInsets.all(8.0), child: Text(item.descRefe, textAlign: TextAlign.center)),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text(
                               item.numValor,
                               textAlign: TextAlign.right,
                               style: TextStyle(
                                 color: item.descTipo == 'P' ? Colors.blue : Colors.red,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ]
                       )).toList(),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- FUNÇÃO CORRIGIDA PARA EVITAR OVERFLOW ---
  Widget _buildDetalheRow(BuildContext context, String titulo, String valor, {Color? cor, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // O título ocupa um espaço fixo
          Text(titulo, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 16),
          // O Expanded força o valor a ocupar o resto do espaço e quebrar a linha
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right, // Alinha o valor à direita
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: cor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}