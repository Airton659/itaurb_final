// lib/widgets/processo_seletivo_card.dart
import 'package:flutter/material.dart';
import '../models/processo_seletivo_model.dart';

class ProcessoSeletivoCardWidget extends StatelessWidget {
  final ProcessoSeletivo processo;
  final VoidCallback? aoTocar;

  const ProcessoSeletivoCardWidget({super.key, required this.processo, this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Processo Seletivo ${processo.numProcesso}/${processo.numExercicio}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                processo.descNome,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(
                    processo.descSituacao,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}