// lib/telas/bairro_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/models/bairro.dart';
import 'package:itaurb_transparente/models/coleta.dart';
import 'package:itaurb_transparente/controllers/favorites_provider.dart';
import 'package:itaurb_transparente/services/notification_service.dart';
import 'package:provider/provider.dart';

class BairroDetailScreen extends StatelessWidget {
  final Bairro bairro;
  final NotificationService _notificationService = NotificationService();

  BairroDetailScreen({super.key, required this.bairro});

  void _toggleFavorito(BuildContext context, FavoritesProvider provider) async {
    final bool isCurrentlyFavorite = provider.isFavorite(bairro.nome);
    
    if (!isCurrentlyFavorite) {
      bool permissionsGranted = await _notificationService.requestPermissions();
      if (!permissionsGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Para receber alertas, por favor, autorize as notificações nas configurações do seu celular.'),
            backgroundColor: Colors.red,
          ));
        }
        return;
      }
      
      await provider.toggleFavorite(bairro.nome);
      _notificationService.agendarNotificacoesBairro(bairro);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notificações ativadas para ${bairro.nome}'), backgroundColor: Theme.of(context).primaryColor));
      }
    } else {
      await provider.toggleFavorite(bairro.nome);
      _notificationService.cancelarNotificacoesBairro(bairro);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notificações desativadas para ${bairro.nome}'), backgroundColor: Colors.red));
      }
    }
  }

  // O resto do arquivo (formatar, popup, build, etc.) permanece o mesmo da
  // versão anterior que já corrigimos para o overflow. Incluindo completo abaixo.

  String _formatarColetas(List<Coleta>? coletas) {
    if (coletas == null || coletas.isEmpty) { return 'Não há coletas programadas.'; }
    return coletas.map((c) => '${c.dia} às ${c.horario}').join('\n');
  }

  void _showInfoPopup(BuildContext context, String tipoColeta) {
    String titulo = ''; IconData icone = Icons.info; Color cor = Colors.grey;
    List<String> oQueDescartar = []; List<String> oQueNaoDescartar = [];
    switch (tipoColeta) {
      case 'Orgânica':
        titulo = 'Coleta Orgânica'; icone = Icons.eco; cor = const Color(0xFF8B4513);
        oQueDescartar = ['Restos de frutas, verduras e legumes.', 'Cascas de ovos.', 'Borra de café e sachês de chá.', 'Restos de alimentos em geral.',];
        oQueNaoDescartar = ['Gorduras e óleos.', 'Excrementos de animais.', 'Qualquer tipo de lixo reciclável ou rejeito.',];
        break;
      case 'Seletiva':
        titulo = 'Coleta Seletiva (Reciclável)'; icone = Icons.recycling; cor = const Color(0xFF007BFF);
        oQueDescartar = ['Papéis (Jornais, revistas, caixas).', 'Plásticos (Garrafas PET, embalagens).', 'Metais (Latinhas, tampas).', 'Vidros (Garrafas, potes de conserva).',];
        oQueNaoDescartar = ['Papéis sujos (gordurosos) ou metalizados.', 'Pilhas, baterias e lâmpadas.', 'Espelhos, cerâmicas e vidros temperados.',];
        break;
      case 'Apoio':
        titulo = 'Coleta de Apoio (Rejeito)'; icone = Icons.delete_forever; cor = Colors.grey.shade700;
        oQueDescartar = ['Lixo de banheiro (papel higiênico, fraldas).', 'Etiquetas e fitas adesivas.', 'Fotografias e papéis metalizados.', 'Esponjas de limpeza e palhas de aço.',];
        oQueNaoDescartar = ['Materiais recicláveis limpos.', 'Resíduos orgânicos.', 'Entulhos ou móveis (usar serviço específico).',];
        break;
    }
    showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [ Icon(icone, color: cor), const SizedBox(width: 8), Flexible(child: Text(titulo, style: TextStyle(color: cor, fontWeight: FontWeight.bold))),]),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('O que descartar:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...oQueDescartar.map((item) => ListTile(dense: true, leading: const Icon(Icons.check, color: Colors.green), title: Text(item))),
                const SizedBox(height: 16),
                const Text('O que NÃO descartar:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...oQueNaoDescartar.map((item) => ListTile(dense: true, leading: const Icon(Icons.close, color: Colors.red), title: Text(item))),
              ],
            ),
          ),
          actions: <Widget>[TextButton(child: const Text('Fechar'), onPressed: () {Navigator.of(context).pop();})],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoritesProvider = context.watch<FavoritesProvider>();
    final isFav = favoritesProvider.isFavorite(bairro.nome);
    return Scaffold(
      appBar: AppBar(
        title: Text(bairro.nome),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? theme.colorScheme.secondary : Colors.white),
            onPressed: () => _toggleFavorito(context, favoritesProvider),
            tooltip: 'Favoritar Bairro',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(context, 'Coleta Orgânica', _formatarColetas(bairro.coletas['Orgânica']), Icons.eco, const Color(0xFF8B4513), () => _showInfoPopup(context, 'Orgânica')),
            _buildInfoCard(context, 'Coleta Seletiva (Reciclável)', _formatarColetas(bairro.coletas['Seletiva']), Icons.recycling, const Color(0xFF007BFF), () => _showInfoPopup(context, 'Seletiva')),
            _buildInfoCard(context, 'Coleta de Apoio (Rejeito)', _formatarColetas(bairro.coletas['Apoio']), Icons.delete_forever, Colors.grey.shade700, () => _showInfoPopup(context, 'Apoio')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String details, IconData icon, Color color, VoidCallback onInfoTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(icon, color: color, size: 32),
                      const SizedBox(width: 12),
                      Flexible(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color))),
                    ],
                  ),
                ),
                IconButton(icon: Icon(Icons.info_outline, color: Colors.grey.shade600), onPressed: onInfoTap, tooltip: 'O que descartar?'),
              ],
            ),
            const Divider(height: 20),
            Text(details, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}