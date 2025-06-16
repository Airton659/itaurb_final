// lib/services/data_cache_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importe para formatação de data
import '../models/contrato_model.dart';
import '../models/legislacao_model.dart';
import '../models/licitacao_model.dart';

class DataCacheService {
  static final DataCacheService instance = DataCacheService._internal();
  DataCacheService._internal();

  List<Licitacao> licitacoes = [];
  List<Contrato> contratos = [];
  List<Legislacao> legislacoes = [];
  
  bool isInitialized = false;

  Future<void> initialize() async {
    if (isInitialized) return;

    debugPrint("Iniciando carregamento de dados em memória (sequencial)...");
    
    final currentYear = DateTime.now().year;
    final previousYear = currentYear - 1;

    // Busca Licitações de 2 anos
    final licitacoesAnoAtual = await _fetchLicitacoes(currentYear.toString());
    final licitacoesAnoAnterior = await _fetchLicitacoes(previousYear.toString());
    licitacoes = [...licitacoesAnoAtual, ...licitacoesAnoAnterior];
    debugPrint("-> Licitações carregadas: ${licitacoes.length}");

    // Busca Contratos (agora corrigido para usar intervalo de datas)
    contratos = await _fetchContratos();
    debugPrint("-> Contratos carregados: ${contratos.length}");
    
    // Busca Legislações de 2 anos
    final legislacoesAnoAtual = await _fetchLegislacoes(currentYear.toString());
    final legislacoesAnoAnterior = await _fetchLegislacoes(previousYear.toString());
    legislacoes = [...legislacoesAnoAtual, ...legislacoesAnoAnterior];
    debugPrint("-> Legislações carregadas: ${legislacoes.length}");
    
    isInitialized = true;
    debugPrint("Carregamento em memória concluído.");
  }

  Future<List<Licitacao>> _fetchLicitacoes(String year) async {
    final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/licitacoes').replace(queryParameters: {
      'type': 'json', 'idCliente': '465', 'pageSize': '100', 'numAno': year, 'page': '1',
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) return (json.decode(response.body) as List).map((data) => Licitacao.fromJson(data)).toList();
    } catch (e) { debugPrint("ERRO AO BUSCAR LICITAÇÕES de $year: $e"); }
    return [];
  }

  // CORRIGIDO: Este método agora usa um intervalo de datas fixo e amplo
  Future<List<Contrato>> _fetchContratos() async {
    final now = DateTime.now();
    // Busca desde o início do ano passado até o fim do ano corrente
    final dtInicio = DateFormat('dd/MM/yyyy').format(DateTime(now.year - 1, 1, 1));
    final dtFim = DateFormat('dd/MM/yyyy').format(DateTime(now.year, 12, 31));

    final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/contratos').replace(queryParameters: {
      'type': 'json', 'idCliente': '465', 'pageSize': '100', 'dtInicio': dtInicio, 'dtFim': dtFim, 'page': '1',
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) return (json.decode(response.body) as List).map((data) => Contrato.fromJson(data)).toList();
    } catch (e) { debugPrint("ERRO AO BUSCAR CONTRATOS: $e"); }
    return [];
  }

  Future<List<Legislacao>> _fetchLegislacoes(String year) async {
    final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/legislacoes').replace(queryParameters: {
      'type': 'json', 'idCliente': '465', 'pageSize': '100', 'numAno': year, 'page': '1',
    });
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) return (json.decode(response.body) as List).map((data) => Legislacao.fromJson(data)).toList();
    } catch (e) { debugPrint("ERRO AO BUSCAR LEGISLAÇÕES de $year: $e"); }
    return [];
  }
}