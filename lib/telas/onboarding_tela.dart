// lib/telas/onboarding_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/telas/home_tela.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingTela extends StatelessWidget {
  const OnboardingTela({super.key});

  void _onOnboardingDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeTela()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // --- LÓGICA DE COR CORRIGIDA AQUI ---
    // Define a cor dos controles com base no brilho do tema atual
    final controlColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    final pageDecoration = PageDecoration(
      titleTextStyle: theme.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w700),
      bodyTextStyle: theme.textTheme.titleLarge!,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: const EdgeInsets.only(bottom: 24),
      pageColor: theme.scaffoldBackgroundColor,
    );

    return Scaffold(
      body: Stack(
        children: [
          IntroductionScreen(
            globalBackgroundColor: theme.scaffoldBackgroundColor,
            pages: [
              PageViewModel(
                title: "Bem-vindo à Itaurb",
                body: "Todas as informações da Empresa de Desenvolvimento de Itabira na palma da sua mão.",
                image: Image.asset('assets/images/logo_itaurb2.png', width: 250),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Funciona Offline",
                body: "Consulte os horários da coleta de lixo do seu bairro mesmo sem conexão com a internet.",
                image: Icon(Icons.wifi_off_rounded, size: 150, color: theme.colorScheme.primary),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Alertas de Coleta",
                body: "Favorite seu bairro para receber notificações e nunca mais perder o dia da coleta de lixo.",
                image: Icon(Icons.notifications_active, size: 150, color: theme.colorScheme.primary),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Dicas de Uso",
                body: "Você pode alterar o tema do aplicativo (claro/escuro) ou rever esta apresentação a qualquer momento na tela 'Sobre e Configurações'.",
                image: Icon(Icons.settings_suggest_outlined, size: 150, color: theme.colorScheme.primary),
                decoration: pageDecoration,
              ),
            ],
            onDone: () => _onOnboardingDone(context),
            onSkip: () => _onOnboardingDone(context),
            showSkipButton: true,
            
            // --- CORES ATUALIZADAS AQUI ---
            skip: Text('Pular', style: TextStyle(fontWeight: FontWeight.w600, color: controlColor)),
            next: Icon(Icons.arrow_forward, color: controlColor),
            done: Text('Concluir', style: TextStyle(fontWeight: FontWeight.w600, color: controlColor)),
            
            dotsDecorator: DotsDecorator(
              size: const Size(10.0, 10.0),
              color: theme.dividerColor,
              activeColor: theme.colorScheme.primary, // Mantemos os pontos azuis para destaque
              activeSize: const Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          
          IgnorePointer(
            child: Image.asset(
              'assets/images/borda.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}