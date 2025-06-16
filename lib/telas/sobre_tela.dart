// lib/telas/sobre_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/providers/theme_provider.dart';
import 'package:itaurb_transparente/telas/onboarding_tela.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SobreTela extends StatelessWidget {
  const SobreTela({super.key});

  // Função auxiliar para abrir URLs
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Não foi possível abrir o link: $url");
    }
  }

  // --- NOVA FUNÇÃO PARA RESETAR E VER O ONBOARDING ---
  void _resetAndShowOnboarding(BuildContext context) async {
    // 1. Acessa o SharedPreferences e remove a flag que "lembra" que o onboarding foi visto.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hasSeenOnboarding');

    // 2. Navega para a tela de Onboarding, substituindo a tela atual (Sobre)
    // para que o fluxo de navegação fique correto após a conclusão.
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingTela()),
      );
    }
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
            const SizedBox(height: 24),
            const Divider(),

            // Seletor de Tema
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preferência de Tema", style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SegmentedButton<ThemeMode>(
                        segments: const <ButtonSegment<ThemeMode>>[
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text('Sistema'),
                            icon: Icon(Icons.brightness_auto),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text('Claro'),
                            icon: Icon(Icons.wb_sunny),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text('Escuro'),
                            icon: Icon(Icons.nightlight_round),
                          ),
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

            const Divider(),

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
              subtitle: const Text('[Seu nome ou nome da empresa]'),
              onTap: () {},
            ),

            const SizedBox(height: 24),
            // --- BOTÃO ADICIONADO AQUI ---
            OutlinedButton.icon(
              icon: const Icon(Icons.slideshow_outlined),
              label: const Text('Ver Apresentação Inicial'),
              onPressed: () => _resetAndShowOnboarding(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}