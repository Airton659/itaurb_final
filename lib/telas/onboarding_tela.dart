// lib/telas/onboarding_tela.dart
import 'package:flutter/material.dart';
import 'package:itaurb_transparente/telas/home_tela.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingTela extends StatelessWidget {
  const OnboardingTela({super.key});

  // Função chamada ao concluir ou pular o onboarding
  void _onOnboardingDone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true); // Marca que o usuário já viu

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeTela()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Decoração da página agora é ciente do tema
    final pageDecoration = PageDecoration(
      // As cores do texto são herdadas do tema atual
      titleTextStyle: theme.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w700),
      bodyTextStyle: theme.textTheme.titleLarge!,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // CORREÇÃO: Removemos pageColor para usar o fundo do tema
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      // Garante que o fundo da tela use a cor do tema
      globalBackgroundColor: theme.scaffoldBackgroundColor,
      pages: [
        PageViewModel(
          title: "Bem-vindo à Itaurb",
          body: "Todas as informações da Empresa de Desenvolvimento de Itabira na palma da sua mão.",
          image: Image.asset('assets/images/logo_itaurb.png', width: 250),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
          ),
        ),
        PageViewModel(
          title: "Alertas de Coleta",
          body: "Favorite seu bairro para receber notificações e nunca mais perder o dia da coleta de lixo.",
          image: Icon(Icons.notifications_active, size: 150, color: theme.colorScheme.primary),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Transparência Total",
          body: "Consulte salários, licitações, contratos e muito mais de forma simples e rápida.",
          image: Icon(Icons.search, size: 150, color: theme.colorScheme.primary),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onOnboardingDone(context),
      onSkip: () => _onOnboardingDone(context),
      showSkipButton: true,
      skip: Text('Pular', style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
      next: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
      done: Text('Começar', style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        // CORREÇÃO: Cor dos pontos agora usa o tema
        color: theme.dividerColor,
        activeColor: theme.colorScheme.primary,
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}