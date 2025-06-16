// lib/telas/pesquisa_global_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/data/bairros_data.dart';
import 'package:itaurb_transparente/models/bairro.dart';
import 'package:itaurb_transparente/services/data_cache_service.dart';
import 'package:itaurb_transparente/telas/bairro_detail_screen.dart';
import '../models/contrato_model.dart';
import '../models/legislacao_model.dart';
import '../models/licitacao_model.dart';
import '../widgets/contrato_card_widget.dart';
import '../widgets/legislacao_card_widget.dart';
import '../widgets/licitacao_card_widget.dart';
import 'contrato_detalhe_tela.dart';
import 'legislacao_detalhe_tela.dart';
import 'licitacao_detalhe_tela.dart';

class PesquisaGlobalTela extends StatefulWidget {
  final String query;
  const PesquisaGlobalTela({super.key, required this.query});

  @override
  State<PesquisaGlobalTela> createState() => _PesquisaGlobalTelaState();
}

class _PesquisaGlobalTelaState extends State<PesquisaGlobalTela> {
  final List<Licitacao> _licitacoesResultados = [];
  final List<Contrato> _contratosResultados = [];
  final List<Legislacao> _legislacoesResultados = [];
  final List<Bairro> _bairrosResultados = [];

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  void _performSearch() {
    final cache = DataCacheService.instance;
    final query = widget.query.toLowerCase();

    // Filtra Licitações
    _licitacoesResultados.addAll(cache.licitacoes.where((l) =>
        l.descObjeto.toLowerCase().contains(query) ||
        l.numLicitacao.contains(query)));

    // Filtra Contratos
    _contratosResultados.addAll(cache.contratos.where((c) =>
        c.descObjeto.toLowerCase().contains(query) ||
        c.descForn.toLowerCase().contains(query) ||
        c.numContrato.contains(query)));

    // Filtra Legislações
    _legislacoesResultados.addAll(cache.legislacoes.where((l) =>
        l.descAssunto.toLowerCase().contains(query) ||
        l.numLegislacao.contains(query)));
    
    // Filtra Bairros
    final bairros = bairrosData.entries
        .map((entry) => Bairro.fromJson(entry.key, entry.value))
        .where((b) => b.nome.toLowerCase().contains(query))
        .toList();
    _bairrosResultados.addAll(bairros);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasResults = _licitacoesResultados.isNotEmpty ||
        _contratosResultados.isNotEmpty ||
        _legislacoesResultados.isNotEmpty ||
        _bairrosResultados.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados para "${widget.query}"'),
      ),
      body: !hasResults
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nenhum resultado encontrado.', style: TextStyle(fontSize: 18)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                if (_bairrosResultados.isNotEmpty)
                  _buildSectionHeader(context, 'Coleta', _bairrosResultados.length),
                ..._bairrosResultados.map((item) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(item.nome),
                        subtitle: const Text("Bairro / Coleta de Lixo"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BairroDetailScreen(bairro: item))),
                      ),
                    )),
                if (_licitacoesResultados.isNotEmpty)
                  _buildSectionHeader(context, 'Licitações', _licitacoesResultados.length),
                ..._licitacoesResultados.map((item) => LicitacaoCardWidget(licitacao: item, aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LicitacaoDetalheTela(licitacao: item))))),
                if (_contratosResultados.isNotEmpty)
                  _buildSectionHeader(context, 'Contratos', _contratosResultados.length),
                ..._contratosResultados.map((item) => ContratoCardWidget(contrato: item, aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContratoDetalheTela(contrato: item))))),
                if (_legislacoesResultados.isNotEmpty)
                  _buildSectionHeader(context, 'Legislações', _legislacoesResultados.length),
                ..._legislacoesResultados.map((item) => LegislacaoCardWidget(legislacao: item, aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LegislacaoDetalheTela(legislacao: item))))),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Chip(
            label: Text('$count resultado(s)'),
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ],
      ),
    );
  }
}