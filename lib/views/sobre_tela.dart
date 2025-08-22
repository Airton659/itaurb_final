// lib/telas/sobre_tela.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:itaurb_transparente/controllers/theme_provider.dart';
import 'package:itaurb_transparente/views/onboarding_tela.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreTela extends StatelessWidget {
  const SobreTela({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Não foi possível abrir o link: $url");
    }
  }

  void _resetAndShowOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hasSeenOnboarding');
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingTela()),
      );
    }
  }

  void _scheduleTestNotification(BuildContext context) {
    // --- CORREÇÃO APLICADA AQUI ---
    // Usando um método de agendamento diferente e mais robusto que evita o erro de tipo.
    // Ele agenda para uma data e hora exatas: agora + 10 segundos.
    final DateTime scheduledDate = DateTime.now().add(const Duration(seconds: 10));

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 99, // Um ID de teste
        channelKey: 'coleta_notification_channel',
        title: '🔔 Teste de Notificação 🔔',
        body: 'Se você está vendo isso, as notificações estão funcionando!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notificação de teste agendada para daqui a 10 segundos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const String appVersion = '1.0.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre e Configurações'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/logo_itaurb.png',
              height: 100,
            ),
            const SizedBox(height: 16),
            Text(
              'Itaurb Transparente',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Versão $appVersion',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text(
              'Este aplicativo foi desenvolvido para facilitar o acesso às informações públicas da Itaurb, promovendo a transparência e a participação cidadã.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preferência de Tema", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SegmentedButton<ThemeMode>(
                        segments: const <ButtonSegment<ThemeMode>>[
                          ButtonSegment<ThemeMode>(value: ThemeMode.system, label: Text('Sistema'), icon: Icon(Icons.brightness_auto)),
                          ButtonSegment<ThemeMode>(value: ThemeMode.light, label: Text('Claro'), icon: Icon(Icons.wb_sunny)),
                          ButtonSegment<ThemeMode>(value: ThemeMode.dark, label: Text('Escuro'), icon: Icon(Icons.nightlight_round)),
                        ],
                        selected: <ThemeMode>{themeProvider.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          themeProvider.setThemeMode(newSelection.first);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 32),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline),
              title: const Text('Fonte de Dados'),
              subtitle: const Text('Portal da Transparência da Itaurb'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchUrl('https://transparencia.itaurb.com.br/'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.code),
              title: const Text('Desenvolvido por'),
              subtitle: const Text('José Airton - Itaurb'),
              onTap: () {},
            ),

            const SizedBox(height: 24),
            
            OutlinedButton.icon(
              icon: const Icon(Icons.slideshow_outlined),
              label: const Text('Ver Apresentação Inicial'),
              onPressed: () => _resetAndShowOnboarding(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.textTheme.bodySmall?.color,
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Testar Notificação (em 10s)'),
              onPressed: () => _scheduleTestNotification(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.textTheme.bodySmall?.color,
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}