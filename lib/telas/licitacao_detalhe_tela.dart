import 'package:flutter/material.dart';
import '../models/licitacao_model.dart';
import '../utils/formatters.dart';

class LicitacaoDetalheTela extends StatefulWidget {
  final Licitacao licitacao;
  const LicitacaoDetalheTela({super.key, required this.licitacao});

  @override
  State<LicitacaoDetalheTela> createState() => _LicitacaoDetalheTelaState();
}

class _LicitacaoDetalheTelaState extends State<LicitacaoDetalheTela> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Licitação ${widget.licitacao.numLicitacao}/${widget.licitacao.numAno}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: _getStatusChip(widget.licitacao.status)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _buildResumoCard(context, textTheme),
          const SizedBox(height: 12),
          _buildDetalhesGeraisCard(context, textTheme),
          const SizedBox(height: 12),
          _buildObjetoCard(context, textTheme),
        ],
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
            Text('Valor Estimado', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              formatarMoeda(widget.licitacao.nuValorEstimado),
              style: textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              children: [
                Expanded(child: _buildInfoColuna(context, icone: Icons.calendar_today_outlined, titulo: 'Publicação', valor: widget.licitacao.dtPublicacao)),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoColuna(context, icone: Icons.timer_off_outlined, titulo: 'Data Limite', valor: widget.licitacao.dtLimite)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetalhesGeraisCard(BuildContext context, TextTheme textTheme) {
     return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetalheRow(context, icone: Icons.gavel, titulo: 'Modalidade', valor: widget.licitacao.descModalidade),
            _buildDetalheRow(context, icone: Icons.account_balance, titulo: 'Unidade', valor: widget.licitacao.descUnidade),
            _buildDetalheRow(context, icone: Icons.folder_open_outlined, titulo: 'Processo Nº', valor: widget.licitacao.numProcesso),
            _buildDetalheRow(context, icone: Icons.schedule, titulo: 'Habilitação', valor: '${widget.licitacao.dtHabilitacao} às ${widget.licitacao.hrHabilitacao}'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildObjetoCard(BuildContext context, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objeto da Licitação', style: textTheme.titleLarge?.copyWith(color: Theme.of(context).primaryColor)),
            const Divider(height: 20, thickness: 1),
            Text(
              widget.licitacao.descObjeto,
              maxLines: _isExpanded ? null : 4,
              overflow: _isExpanded ? null : TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(_isExpanded ? 'Ler menos' : 'Ler mais', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalheRow(BuildContext context, {required IconData icone, required String titulo, required String valor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: Colors.grey[500], size: 22),
          const SizedBox(width: 16),
          Text(titulo, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoColuna(BuildContext context, {required IconData icone, required String titulo, required String valor}) {
    return Row(
      children: [
        Icon(icone, color: Colors.grey[400], size: 28),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.bodySmall),
            Text(valor, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
  
  Widget _getStatusChip(String status) {
    Color cor;
    switch (status.toLowerCase()) {
      case 'homologada': cor = Colors.green; break;
      case 'em andamento': cor = Colors.blue; break;
      case 'fracassada': case 'anulada': cor = Colors.red; break;
      default: cor = Colors.grey;
    }
    return Chip(
      label: Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: cor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}