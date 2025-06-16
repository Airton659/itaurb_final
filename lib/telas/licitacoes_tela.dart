// lib/telas/licitacoes_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/services/data_cache_service.dart';
import 'package:itaurb_transparente/telas/licitacao_detalhe_tela.dart';
import '../models/licitacao_model.dart';
import '../widgets/licitacao_card_widget.dart';

class LicitacoesPage extends StatefulWidget {
  const LicitacoesPage({super.key});
  @override
  State<LicitacoesPage> createState() => _LicitacoesPageState();
}

class _LicitacoesPageState extends State<LicitacoesPage> {
  List<Licitacao> _todasLicitacoes = [];
  List<Licitacao> _licitacoesFiltradas = [];
  List<String> _modalidades = ['Todos'];
  List<String> _status = ['Todos'];
  String _filtroModalidadeAtual = 'Todos';
  String _filtroStatusAtual = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLicitacoesFromCache();
    _searchController.addListener(_aplicarFiltros);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadLicitacoesFromCache() {
    final licitacoes = DataCacheService.instance.licitacoes;
    
    // ORDENAÇÃO APLICADA AQUI
    licitacoes.sort((a, b) {
      final anoA = int.tryParse(a.numAno) ?? 0;
      final anoB = int.tryParse(b.numAno) ?? 0;
      if (anoB.compareTo(anoA) != 0) {
        return anoB.compareTo(anoA); // Ano mais recente primeiro
      }
      final numA = int.tryParse(a.numLicitacao) ?? 0;
      final numB = int.tryParse(b.numLicitacao) ?? 0;
      return numB.compareTo(numA); // Número da licitação mais recente primeiro
    });
    
    final modalidadesUnicas = licitacoes.map((l) => l.descModalidade).toSet().toList();
    final statusUnicos = licitacoes.map((l) => l.status).toSet().toList();
    
    if(mounted) {
      setState(() {
        _todasLicitacoes = licitacoes;
        _licitacoesFiltradas = licitacoes;
        _modalidades = ['Todos', ...modalidadesUnicas];
        _status = ['Todos', ...statusUnicos];
      });
    }
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _licitacoesFiltradas = _todasLicitacoes.where((licitacao) {
        final filtroModalidadeOk = _filtroModalidadeAtual == 'Todos' || licitacao.descModalidade == _filtroModalidadeAtual;
        final filtroStatusOk = _filtroStatusAtual == 'Todos' || licitacao.status == _filtroStatusAtual;
        final filtroQueryOk = query.isEmpty || licitacao.descObjeto.toLowerCase().contains(query);
        return filtroModalidadeOk && filtroStatusOk && filtroQueryOk;
      }).toList();
    });
  }
  
  Future<void> _forceSync() async {
    await DataCacheService.instance.initialize();
    _loadLicitacoesFromCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Licitações')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por palavra-chave no objeto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          _buildFilterSection('Modalidade:', _modalidades, _filtroModalidadeAtual, (value) {
            setState(() => _filtroModalidadeAtual = value);
            _aplicarFiltros();
          }),
          _buildFilterSection('Status:', _status, _filtroStatusAtual, (value) {
            setState(() => _filtroStatusAtual = value);
            _aplicarFiltros();
          }),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _forceSync,
              child: _licitacoesFiltradas.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Nenhuma licitação encontrada.', textAlign: TextAlign.center),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      itemCount: _licitacoesFiltradas.length,
                      itemBuilder: (context, index) {
                        final licitacao = _licitacoesFiltradas[index];
                        return LicitacaoCardWidget(
                          licitacao: licitacao,
                          aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LicitacaoDetalheTela(licitacao: licitacao))),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String currentFilter, Function(String) onFilterChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(option),
                    selected: currentFilter == option,
                    onSelected: (selected) {
                      if (selected) onFilterChanged(option);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}