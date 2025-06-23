// lib/telas/contratos_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/services/data_cache_service.dart';
import 'package:itaurb_transparente/telas/contrato_detalhe_tela.dart';
import 'package:itaurb_transparente/widgets/empty_state_widget.dart';
import '../models/contrato_model.dart';
import '../widgets/contrato_card_widget.dart';
import '../widgets/loading_list_shimmer.dart';

class ContratosTela extends StatefulWidget {
  const ContratosTela({super.key});
  @override
  State<ContratosTela> createState() => _ContratosTelaState();
}

class _ContratosTelaState extends State<ContratosTela> {
  List<Contrato> _todosContratos = [];
  List<Contrato> _contratosFiltrados = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadContratosFromCache);
    _searchController.addListener(_aplicarFiltros);
  }

  @override
  void dispose() {
    _searchController.removeListener(_aplicarFiltros);
    _searchController.dispose();
    super.dispose();
  }

  void _loadContratosFromCache() {
    final contratos = DataCacheService.instance.contratos;
    
    contratos.sort((a, b) {
      try {
        final partsA = a.numContrato.split('/');
        final partsB = b.numContrato.split('/');
        final anoB = int.parse(partsB.length > 1 ? partsB[1] : '0');
        final anoA = int.parse(partsA.length > 1 ? partsA[1] : '0');
        if (anoB.compareTo(anoA) != 0) { return anoB.compareTo(anoA); }
        final numB = int.parse(partsB[0]);
        final numA = int.parse(partsA[0]);
        return numB.compareTo(numA);
      } catch (e) { return 0; }
    });

    if(mounted) {
      setState(() {
        _todosContratos = contratos;
        _contratosFiltrados = contratos;
        _isLoading = false;
      });
    }
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _contratosFiltrados = _todosContratos.where((contrato) {
        return contrato.descObjeto.toLowerCase().contains(query) ||
               contrato.descForn.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _forceSync() async {
    setState(() => _isLoading = true);
    await DataCacheService.instance.initialize();
    _loadContratosFromCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contratos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por objeto ou fornecedor...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _isLoading 
                ? const LoadingListShimmer()
                : RefreshIndicator(
                    onRefresh: _forceSync,
                    child: _contratosFiltrados.isEmpty
                        ? LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: const EmptyStateWidget(
                              icon: Icons.description_outlined,
                              title: "Nenhum Contrato",
                              message: "Não há contratos que correspondam à sua busca.",
                            )
                          ),
                        ))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                            itemCount: _contratosFiltrados.length,
                            itemBuilder: (context, index) {
                              final contrato = _contratosFiltrados[index];
                              return ContratoCardWidget(
                                contrato: contrato,
                                aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContratoDetalheTela(contrato: contrato))),
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