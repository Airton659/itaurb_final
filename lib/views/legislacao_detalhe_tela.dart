// lib/telas/legislacao_detalhe_tela.dart
import 'package:flutter/material.dart';
import '../models/legislacao_model.dart';

class LegislacaoDetalheTela extends StatefulWidget {
  final Legislacao legislacao;
  const LegislacaoDetalheTela({super.key, required this.legislacao});
  @override
  State<LegislacaoDetalheTela> createState() => _LegislacaoDetalheTelaState();
}

class _LegislacaoDetalheTelaState extends State<LegislacaoDetalheTela> {
  bool _isResumoExpanded = false;
  String _formatarData(String dataCompleta) => dataCompleta.split(' ')[0];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Verifica se o resumo tem conteúdo para ser exibido
    final bool hasResumo = widget.legislacao.descResumo.trim().isNotEmpty &&
        widget.legislacao.descResumo != 'Não informado';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Legislação ${widget.legislacao.numLegislacao}/${widget.legislacao.numExercicio}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            widget.legislacao.descAssunto,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: _getStatusChip(widget.legislacao.stRevogada),
          ),
          const SizedBox(height: 20),
          _buildDetalhesCard(context),
          const SizedBox(height: 16),
          // --- LÓGICA DE EXIBIÇÃO CONDICIONAL ADICIONADA ---
          if (hasResumo) _buildResumoCard(context, textTheme),
        ],
      ),
    );
  }

  Widget _buildDetalhesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildDetalheRow(context,
                icone: Icons.calendar_today_outlined,
                titulo: 'Data da Legislação',
                valor: _formatarData(widget.legislacao.dtLegislacao)),
            _buildDetalheRow(context,
                icone: Icons.draw_outlined,
                titulo: 'Data da Assinatura',
                valor: _formatarData(widget.legislacao.dtAssinatura)),
          ],
        ),
      ),
    );
  }

  Widget _buildResumoCard(BuildContext context, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo',
                style: textTheme.titleLarge
                    ?.copyWith(color: Theme.of(context).primaryColor)),
            const Divider(height: 20, thickness: 1),
            Text(
              widget.legislacao.descResumo,
              maxLines: _isResumoExpanded ? null : 6,
              overflow: _isResumoExpanded ? null : TextOverflow.ellipsis,
              // --- COR DA FONTE CORRIGIDA ---
              // Removemos a cor fixa 'Colors.black54' para herdar do tema
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            // A lógica de "Ler mais" já tratava textos longos, mantida
            if (widget.legislacao.descResumo.length > 200)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _isResumoExpanded = !_isResumoExpanded),
                  child: Text(_isResumoExpanded ? 'Ler menos' : 'Ler mais',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalheRow(BuildContext context,
      {required IconData icone, required String titulo, required String valor}) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icone, color: Colors.grey[500], size: 22),
          const SizedBox(width: 16),
          Text(titulo, style: textTheme.titleSmall),
          const Spacer(),
          Text(valor, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _getStatusChip(bool isRevogada) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        isRevogada ? 'Revogada' : 'Em Vigor',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor:
          isRevogada ? Colors.red[600] : theme.primaryColor,
      avatar: Icon(
          isRevogada ? Icons.cancel_outlined : Icons.check_circle_outline,
          color: Colors.white,
          size: 18),
    );
  }
}