// lib/telas/servidores_tela.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:itaurb_transparente/views/servidor_detalhe_tela.dart';
import '../models/servidor_model.dart';
import 'servidor_card_widget.dart';
import 'loading_list_shimmer.dart';

class ServidoresTela extends StatefulWidget {
  const ServidoresTela({super.key});
  @override
  State<ServidoresTela> createState() => _ServidoresTelaState();
}

class _ServidoresTelaState extends State<ServidoresTela> {
  bool _isLoading = false;
  List<Servidor> _servidores = [];
  String? _mesSelecionado = '05'; // Mês padrão
  String? _anoSelecionado = '2025'; // Ano padrão

  Future<void> _fetchServidores() async {
    if (_mesSelecionado == null || _anoSelecionado == null) return;
    setState(() => _isLoading = true);

    final competencia = '$_mesSelecionado/$_anoSelecionado';
    final uri = Uri.parse(
            'https://dadosabertos-portalfacil.azurewebsites.net/api/servidores')
        .replace(queryParameters: {
      'type': 'json',
      'idCliente': '465',
      'pageSize': '100',
      'numAno': competencia,
      'page': '1'
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        final servidores =
            jsonResponse.map((data) => Servidor.fromJson(data)).toList();
        setState(() {
          _servidores = servidores;
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar');
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicia a busca com os valores padrão ao abrir a tela
    _fetchServidores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salários dos Servidores')),
      body: Column(
        children: [
          // --- CONTAINER DO FILTRO CORRIGIDO ---
          Container(
            padding: const EdgeInsets.all(16),
            // Cor alterada para se adaptar ao tema
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(child: _buildDropdownMes()),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownAno()),
                const SizedBox(width: 16),
                // Botão agora usa o estilo do tema
                ElevatedButton(
                  onPressed: _isLoading ? null : _fetchServidores,
                  child: const Icon(Icons.search),
                )
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingListShimmer()
                : _servidores.isEmpty
                    ? const Center(
                        child: Text(
                            'Nenhum dado encontrado para a data selecionada.'))
                    : ListView.builder(
                        itemCount: _servidores.length,
                        itemBuilder: (context, index) {
                          final servidor = _servidores[index];
                          return ServidorCardWidget(
                            servidor: servidor,
                            aoTocar: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ServidorDetalheTela(
                                              servidor: servidor)));
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Widgets auxiliares _buildDropdownMes e _buildDropdownAno
  Widget _buildDropdownMes() {
    return DropdownButtonFormField<String>(
        value: _mesSelecionado,
        decoration:
            const InputDecoration(labelText: 'Mês', border: OutlineInputBorder()),
        items: List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'))
            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
            .toList(),
        onChanged: (value) => setState(() => _mesSelecionado = value));
  }

  Widget _buildDropdownAno() {
    return DropdownButtonFormField<String>(
        value: _anoSelecionado,
        decoration:
            const InputDecoration(labelText: 'Ano', border: OutlineInputBorder()),
        items: List.generate(5, (i) => (DateTime.now().year - i).toString())
            .map((a) => DropdownMenuItem(value: a, child: Text(a)))
            .toList(),
        onChanged: (value) => setState(() => _anoSelecionado = value));
  }
}