import 'package:flutter/material.dart';
import '../../models/contrato_model.dart';
import '../../utils/formatters.dart';

class ContratoDetalheTela extends StatefulWidget {
  final Contrato contrato;
  const ContratoDetalheTela({super.key, required this.contrato});

  @override
  State<ContratoDetalheTela> createState() => _ContratoDetalheTelaState();
}

class _ContratoDetalheTelaState extends State<ContratoDetalheTela> {
  bool _isObjetoExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contrato ${widget.contrato.numContrato}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          _buildResumoHeroCard(context),
          const SizedBox(height: 12),
          _buildFornecedorCard(context),
          const SizedBox(height: 12),
          _buildObjetoCard(context),
        ],
      ),
    );
  }

  Widget _buildResumoHeroCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      color: theme.primaryColor, // Usa cor primária
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('VALOR TOTAL DO CONTRATO', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              formatarMoeda(widget.contrato.vlContrato),
              style: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32, color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimelinePoint(context, icon: Icons.flag_circle_outlined, label: 'Início da Vigência', date: widget.contrato.dtInicio),
                Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Divider(color: Colors.white54, thickness: 1))),
                _buildTimelinePoint(context, icon: Icons.flag_circle, label: 'Fim da Vigência', date: widget.contrato.dtFim),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFornecedorCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            _buildDetalheRow(context, icone: Icons.business_center_outlined, titulo: 'Fornecedor Contratado', valor: widget.contrato.descForn),
            _buildDetalheRow(context, icone: Icons.badge_outlined, titulo: 'CPF/CNPJ', valor: widget.contrato.numCpfCnpj),
          ],
        ),
      ),
    );
  }

  Widget _buildObjetoCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objeto do Contrato', style: theme.textTheme.titleLarge?.copyWith(color: theme.primaryColor)),
            const Divider(height: 20, thickness: 1),
            Text(
              widget.contrato.descObjeto,
              maxLines: _isObjetoExpanded ? null : 5,
              overflow: _isObjetoExpanded ? null : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _isObjetoExpanded = !_isObjetoExpanded),
                child: Text(_isObjetoExpanded ? 'Ler menos' : 'Ler mais', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Widgets auxiliares...
  Widget _buildTimelinePoint(BuildContext context, {required IconData icon, required String label, required String date}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.white70)),
        Text(date, style: textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
  
  Widget _buildDetalheRow(BuildContext context, {required IconData icone, required String titulo, required String valor}) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: Colors.grey[500], size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(valor, style: textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}