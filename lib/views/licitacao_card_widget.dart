import 'package:flutter/material.dart';
import '../models/licitacao_model.dart';

class LicitacaoCardWidget extends StatelessWidget {
  final Licitacao licitacao;
  final VoidCallback? aoTocar;

  const LicitacaoCardWidget({
    super.key,
    required this.licitacao,
    this.aoTocar,
  });

  IconData _getIconePorModalidade(String modalidade) {
    // ... (lógica do ícone sem alterações)
    if (modalidade.toLowerCase().contains('pregão')) return Icons.gavel_outlined;
    if (modalidade.toLowerCase().contains('dispensa')) return Icons.receipt_long_outlined;
    if (modalidade.toLowerCase().contains('credenciamento')) return Icons.assignment_ind_outlined;
    return Icons.article_outlined;
  }

  Color _getCorDoStatus(String status) {
    // ... (lógica da cor sem alterações)
    switch (status.toLowerCase()) {
      case 'homologada': return Colors.green;
      case 'em andamento': return Colors.orange;
      case 'fracassada': case 'anulada': return Colors.red;
      default: return Colors.grey;
    }
  }

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _getIconePorModalidade(licitacao.descModalidade),
                    color: theme.primaryColor, // Usa a cor primária do tema
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${licitacao.descModalidade} ${licitacao.numLicitacao}/${licitacao.numAno}',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          licitacao.descObjeto,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text(
                    licitacao.status,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: _getCorDoStatus(licitacao.status),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
