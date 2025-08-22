// lib/services/data_cache_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importe o SharedPreferences
import 'contrato_model.dart';
import 'legislacao_model.dart';
import 'licitacao_model.dart';

class DataCacheService {
  static final DataCacheService instance = DataCacheService._internal();
  DataCacheService._internal();

  List<Licitacao> licitacoes = [];
  List<Contrato> contratos = [];
  List<Legislacao> legislacoes = [];
  
  bool isInitialized = false;
  static const String lastSyncKey = 'last_sync_timestamp'; // Chave para salvar a data

  Future<void> initialize() async {
    if (isInitialized) return;
    debugPrint("Iniciando carregamento de dados em memória (sequencial)...");
    
    final currentYear = DateTime.now().year.toString();
    final previousYear = (DateTime.now().year - 1).toString();

    final licitacoesAnoAtual = await _fetchLicitacoes(currentYear);
    final licitacoesAnoAnterior = await _fetchLicitacoes(previousYear);
    licitacoes = [...licitacoesAnoAtual, ...licitacoesAnoAnterior];
    debugPrint("-> Licitações carregadas: ${licitacoes.length}");

    contratos = await _fetchContratos();
    debugPrint("-> Contratos carregados: ${contratos.length}");
    
    final legislacoesAnoAtual = await _fetchLegislacoes(currentYear);
    final legislacoesAnoAnterior = await _fetchLegislacoes(previousYear.toString());
    legislacoes = [...legislacoesAnoAtual, ...legislacoesAnoAnterior];
    debugPrint("-> Legislações carregadas: ${legislacoes.length}");
    
    isInitialized = true;
    
    // --- ALTERAÇÃO AQUI ---
    // Salva o timestamp da sincronização bem-sucedida
    await _saveLastSyncTimestamp();
    
    debugPrint("Carregamento em memória concluído.");
  }

  // --- NOVOS MÉTODOS ---
  Future<void> _saveLastSyncTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastSyncKey, DateTime.now().toIso8601String());
  }

  Future<String> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(lastSyncKey);
    if (timestamp == null) {
      return "Nunca";
    }
    final dateTime = DateTime.parse(timestamp);
    // Formata a data para um formato amigável
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  // --- FIM DOS NOVOS MÉTODOS ---

  Future<List<Licitacao>> _fetchLicitacoes(String year) async {
    final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/licitacoes').replace(queryParameters: {'type': 'json', 'idCliente': '465', 'pageSize': '100', 'numAno': year, 'page': '1'});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) return (json.decode(response.body) as List).map((data) => Licitacao.fromJson(data)).toList();
    } catch (e) { debugPrint("ERRO AO BUSCAR LICITAÇÕES de $year: $e"); }
    return [];
  }

  Future<List<Contrato>> _fetchContratos() async {
    final now = DateTime.now();
    final dtInicio = DateFormat('dd/MM/yyyy').format(DateTime(now.year - 1, 1, 1));
    final dtFim = DateFormat('dd/MM/yyyy').format(DateTime(now.year, 12, 31));
    final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/contratos').replace(queryParameters: {'type': 'json', 'idCliente': '465', 'pageSize': '100', 'dtInicio': dtInicio, 'dtFim': dtFim, 'page': '1'});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) return (json.decode(response.body) as List).map((data) => Contrato.fromJson(data)).toList();
    } catch (e) { debugPrint("ERRO AO BUSCAR CONTRATOS: $e"); }
    return [];
  }

  Future<List<Legislacao>> _fetchLegislacoes(String year) async {
    final uri = Uri.parse('https://dadosabertos-portalfacil.azurewebsites.net/api/legislacoes').replace(queryParameters: {'type': 'json', 'idCliente': '465', 'pageSize': '100', 'numAno': year, 'page': '1'});
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) return (json.decode(response.body) as List).map((data) => Legislacao.fromJson(data)).toList();
    } catch (e) { debugPrint("ERRO AO BUSCAR LEGISLAÇÕES de $year: $e"); }
    return [];
  }
}