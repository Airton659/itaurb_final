// lib/telas/legislacoes_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/services/data_cache_service.dart';
import 'package:itaurb_transparente/telas/legislacao_detalhe_tela.dart';
import '../models/legislacao_model.dart';
import '../widgets/legislacao_card_widget.dart';

class LegislacoesTela extends StatefulWidget {
  const LegislacoesTela({super.key});
  @override
  State<LegislacoesTela> createState() => _LegislacoesTelaState();
}

class _LegislacoesTelaState extends State<LegislacoesTela> {
  List<Legislacao> _todasLegislacoes = [];
  List<Legislacao> _legislacoesFiltradas = [];
  String _filtroStatus = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLegislacoesFromCache();
    _searchController.addListener(_aplicarFiltros);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadLegislacoesFromCache() {
    final legislacoes = DataCacheService.instance.legislacoes;
    
    // ORDENAÇÃO APLICADA AQUI
    legislacoes.sort((a, b) {
      final anoA = int.tryParse(a.numExercicio) ?? 0;
      final anoB = int.tryParse(b.numExercicio) ?? 0;
      if (anoB.compareTo(anoA) != 0) {
        return anoB.compareTo(anoA); // Ano mais recente primeiro
      }
      final numA = int.tryParse(a.numLegislacao) ?? 0;
      final numB = int.tryParse(b.numLegislacao) ?? 0;
      return numB.compareTo(numA); // Número da legislação mais recente primeiro
    });

    if(mounted) {
      setState(() {
        _todasLegislacoes = legislacoes;
        _legislacoesFiltradas = legislacoes;
      });
    }
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _legislacoesFiltradas = _todasLegislacoes.where((legislacao) {
        final filtroQueryOk = query.isEmpty || legislacao.descAssunto.toLowerCase().contains(query);
        bool filtroStatusOk;
        if (_filtroStatus == 'Todos') {
          filtroStatusOk = true;
        } else if (_filtroStatus == 'Em Vigor') {
          filtroStatusOk = !legislacao.stRevogada;
        } else {
          filtroStatusOk = legislacao.stRevogada;
        }
        return filtroQueryOk && filtroStatusOk;
      }).toList();
    });
  }

  Future<void> _forceSync() async {
    await DataCacheService.instance.initialize();
    _loadLegislacoesFromCache();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legislações'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por assunto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Todos', 'Em Vigor', 'Revogada'].map((status) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: _filtroStatus == status,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _filtroStatus = status);
                        _aplicarFiltros();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _forceSync,
              child: _legislacoesFiltradas.isEmpty
                  ? const Center(child: Text('Nenhuma legislação encontrada.'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      itemCount: _legislacoesFiltradas.length,
                      itemBuilder: (context, index) {
                        final legislacao = _legislacoesFiltradas[index];
                        return LegislacaoCardWidget(
                          legislacao: legislacao,
                          aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LegislacaoDetalheTela(legislacao: legislacao))),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}