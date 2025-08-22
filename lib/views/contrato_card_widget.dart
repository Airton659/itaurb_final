import 'package:flutter/material.dart';
import 'package:itaurb_transparente/services/formatters.dart';
import '../models/contrato_model.dart';

class ContratoCardWidget extends StatelessWidget {
  final Contrato contrato;
  final VoidCallback? aoTocar;

  const ContratoCardWidget({
    super.key,
    required this.contrato,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contrato ${contrato.numContrato}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                contrato.descForn,
                style: theme.textTheme.bodySmall,
              ),
              const Divider(height: 20),
              Text(
                contrato.descObjeto,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(
                    formatarMoeda(contrato.vlContrato),
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  avatar: Icon(Icons.monetization_on_outlined, color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}