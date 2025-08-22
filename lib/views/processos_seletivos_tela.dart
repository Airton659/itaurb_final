import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:itaurb_transparente/models/processo_seletivo_model.dart';
import 'package:itaurb_transparente/views/processo_seletivo_detalhe_tela.dart';
import 'package:itaurb_transparente/views/processo_seletivo_card.dart';
import 'loading_list_shimmer.dart'; 

class ProcessosSeletivosTela extends StatefulWidget {
  const ProcessosSeletivosTela({super.key});
  @override
  State<ProcessosSeletivosTela> createState() => _ProcessosSeletivosTelaState();
}

class _ProcessosSeletivosTelaState extends State<ProcessosSeletivosTela> {
  bool _isLoading = true;
  List<ProcessoSeletivo> _todosProcessos = [];
  List<ProcessoSeletivo> _processosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProcessosSeletivos();
    _searchController.addListener(() {
      _aplicarFiltros();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProcessosSeletivos() async {
    setState(() => _isLoading = true);
    List<ProcessoSeletivo> todosOsResultados = [];
    final anoAtual = DateTime.now().year;
    final anosParaBuscar = [anoAtual, anoAtual - 1, anoAtual - 2, 2023].toSet().toList();
    try {
      final List<Future<http.Response>> requests = anosParaBuscar.map((ano) {
        final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/procseletivos').replace(queryParameters: {'type': 'json', 'idCliente': '465', 'pageSize': '100', 'numAno': ano.toString(), 'page': '1'});
        return http.get(uri);
      }).toList();
      final responses = await Future.wait(requests);
      for (final response in responses) {
        if (response.statusCode == 200 && response.body.trim().startsWith('[')) {
          List<dynamic> jsonResponse = json.decode(response.body);
          todosOsResultados.addAll(jsonResponse.map((data) => ProcessoSeletivo.fromJson(data)));
        }
      }
      final idsUnicos = <String>{};
      todosOsResultados.retainWhere((processo) => idsUnicos.add('${processo.numExercicio}-${processo.numProcesso}'));
      todosOsResultados.sort((a, b) {
        int compareAno = b.numExercicio.compareTo(a.numExercicio);
        if (compareAno != 0) return compareAno;
        return int.parse(b.numProcesso).compareTo(int.parse(a.numProcesso));
      });
      if (mounted) {
        setState(() {
          _todosProcessos = todosOsResultados;
          _processosFiltrados = todosOsResultados;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _processosFiltrados = _todosProcessos.where((p) {
        return p.descNome.toLowerCase().contains(query);
      }).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concursos e Seleções'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nome do processo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingListShimmer()
                : RefreshIndicator(
                    onRefresh: _fetchProcessosSeletivos,
                    child: _processosFiltrados.isEmpty
                        ? const Center(child: Text('Nenhum processo seletivo encontrado.'))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                            itemCount: _processosFiltrados.length,
                            itemBuilder: (context, index) {
                              final processo = _processosFiltrados[index];
                              return ProcessoSeletivoCardWidget(
                                processo: processo,
                                aoTocar: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProcessoSeletivoDetalheTela(processo: processo))),
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