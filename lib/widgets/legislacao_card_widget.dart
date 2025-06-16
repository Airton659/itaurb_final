
// lib/widgets/legislacao_card_widget.dart

import 'package:flutter/material.dart';
import '../models/legislacao_model.dart';

class LegislacaoCardWidget extends StatelessWidget {
  final Legislacao legislacao;
  final VoidCallback? aoTocar;

  const LegislacaoCardWidget({
    super.key,
    required this.legislacao,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Legislação Nº ${legislacao.numLegislacao}/${legislacao.numExercicio}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(height: 16),
              Text(
                legislacao.descAssunto,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(
                    legislacao.stRevogada ? 'Revogada' : 'Em Vigor',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: legislacao.stRevogada ? Colors.red[600] : Colors.green[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}