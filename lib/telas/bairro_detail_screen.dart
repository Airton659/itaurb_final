// lib/telas/bairro_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/models/coleta.dart';
import 'package:itaurb_transparente/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import '../models/bairro.dart';
import '../services/notification_service.dart';

class BairroDetailScreen extends StatelessWidget {
  final Bairro bairro;

  const BairroDetailScreen({super.key, required this.bairro});

  void _toggleFavorito(BuildContext context, FavoritesProvider provider) async {
    final notificationService = NotificationService();
    final bool isFavoriting = !provider.isFavorite(bairro.nome);

    // Atualiza o estado central através do provider
    await provider.toggleFavorite(bairro.nome);

    if (isFavoriting) {
      bool permissionsGranted = await notificationService.requestPermissions();
      if (permissionsGranted) {
        notificationService.agendarNotificacoesBairro(bairro);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notificações ativadas para ${bairro.nome}'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      } else {
        await provider.toggleFavorite(bairro.nome); // Desfaz a ação
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Permissão de notificação negada.'),
            backgroundColor: Colors.red,
          ));
        }
      }
    } else {
      notificationService.cancelarNotificacoesBairro(bairro);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificações desativadas.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFav = favoritesProvider.isFavorite(bairro.nome);

        return Scaffold(
          appBar: AppBar(
            title: Text(bairro.nome),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? theme.colorScheme.secondary : Colors.white,
                ),
                onPressed: () => _toggleFavorito(context, favoritesProvider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTipoColetaSection(context, 'Orgânica', const Color(0xFF8B4513)),
                const SizedBox(height: 24),
                _buildTipoColetaSection(context, 'Seletiva', theme.primaryColor),
                const SizedBox(height: 24),
                _buildTipoColetaSection(context, 'Apoio', Colors.orange),
                const SizedBox(height: 24),
                isFav
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Você receberá notificações um dia antes de cada coleta.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Marque como favorito para receber notificações.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  // MÉTODO RESTAURADO E COMPLETO
  Widget _buildTipoColetaSection(BuildContext context, String tipoColeta, Color cor) {
    final List<Coleta> coletas = bairro.coletas[tipoColeta]
            ?.map((c) => Coleta.fromJson(c.toJson()))
            .toList() ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Coleta $tipoColeta',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (coletas.isEmpty)
          const Card(
            child: ListTile(
              title: Text('Não há coletas programadas deste tipo.'),
            ),
          )
        else
          Column(
            children: coletas.map((coleta) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: cor),
                  title: Text(coleta.dia),
                  subtitle: Text('Horário: ${coleta.horario}'),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}