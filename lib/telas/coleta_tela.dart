// lib/telas/coleta_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/data/bairros_data.dart'; // Importe a fonte de dados correta
import 'package:itaurb_transparente/models/bairro.dart';
import 'package:itaurb_transparente/providers/favorites_provider.dart';
import 'package:itaurb_transparente/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'bairro_detail_screen.dart';

class ColetaTela extends StatefulWidget {
  const ColetaTela({super.key});

  @override
  State<ColetaTela> createState() => _ColetaTelaState();
}

class _ColetaTelaState extends State<ColetaTela> {
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _searchController = TextEditingController();

  List<Bairro> _todosOsBairros = [];
  List<Bairro> _bairrosFiltrados = [];

  @override
  void initState() {
    super.initState();
    // --- CORREÇÃO APLICADA AQUI ---
    // Carrega os bairros diretamente do arquivo de dados, não mais do cache.
    _todosOsBairros = bairrosData.entries.map((entry) {
      return Bairro.fromJson(entry.key, entry.value);
    }).toList();

    _todosOsBairros.sort((a, b) => a.nome.compareTo(b.nome));
    _bairrosFiltrados = _todosOsBairros;
    _searchController.addListener(_aplicarFiltros);
  }

  @override
  void dispose() {
    _searchController.removeListener(_aplicarFiltros);
    _searchController.dispose();
    super.dispose();
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _bairrosFiltrados = _todosOsBairros.where((bairro) {
        return query.isEmpty || bairro.nome.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _toggleFavorito(FavoritesProvider provider, Bairro bairro) async {
    final bool isFavoriting = !provider.isFavorite(bairro.nome);
    await provider.toggleFavorite(bairro.nome);
    
    if (isFavoriting) {
      bool permissionsGranted = await _notificationService.requestPermissions();
      if (permissionsGranted) {
        _notificationService.agendarNotificacoesBairro(bairro);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notificações ativadas para ${bairro.nome}'), backgroundColor: Theme.of(context).primaryColor));
        }
      } else {
        await provider.toggleFavorite(bairro.nome);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permissão de notificação negada.'), backgroundColor: Colors.red));
        }
      }
    } else {
      _notificationService.cancelarNotificacoesBairro(bairro);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notificações desativadas para ${bairro.nome}'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favoritos = _bairrosFiltrados.where((b) => favoritesProvider.isFavorite(b.nome)).toList();
        final outros = _bairrosFiltrados.where((b) => !favoritesProvider.isFavorite(b.nome)).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Coleta de Lixo por Bairro')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar seu bairro...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
              ),
              Expanded(
                child: _bairrosFiltrados.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('Nenhum bairro encontrado')))
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        children: [
                          if (favoritos.isNotEmpty)
                            _buildSectionHeader('Favoritos', Icons.star),
                          ...favoritos.map((bairro) => _buildBairroTile(bairro, favoritesProvider)),

                          if (outros.isNotEmpty)
                            _buildSectionHeader('Outros Bairros', Icons.list_alt),
                          ...outros.map((bairro) => _buildBairroTile(bairro, favoritesProvider)),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: title == 'Favoritos' ? theme.colorScheme.secondary : theme.textTheme.bodySmall?.color),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }

  Widget _buildBairroTile(Bairro bairro, FavoritesProvider provider) {
    final theme = Theme.of(context);
    final bool isFav = provider.isFavorite(bairro.nome);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(bairro.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.star : Icons.star_border,
            color: isFav ? theme.colorScheme.secondary : Colors.grey,
            size: 30,
          ),
          onPressed: () => _toggleFavorito(provider, bairro),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BairroDetailScreen(bairro: bairro)),
          );
        },
      ),
    );
  }
}