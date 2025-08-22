import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:itaurb_transparente/controllers/favorites_provider.dart';
import 'package:itaurb_transparente/views/coleta_tela.dart';

void main() {
  // Cria um widget pai para fornecer o FavoritesProvider.
  Widget testWidget({required Widget child}) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(home: child),
    );
  }

  group('ColetaTela', () {
    testWidgets('should display a list of all neighborhoods', (WidgetTester tester) async {
      // Constrói o widget da tela de coleta.
      await tester.pumpWidget(testWidget(child: const ColetaTela()));

      // A lista de bairros deve ser exibida.
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should filter the list of neighborhoods based on search query', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget(child: const ColetaTela()));

      // Digita "centro" no campo de busca.
      await tester.enterText(find.byType(TextField), 'centro');
      await tester.pump();

      // Verifica se apenas os bairros que contêm "centro" são exibidos.
      expect(find.text('CENTRO'), findsOneWidget);
      expect(find.text('CENTRO - IGREJA DO ROSÁRIO'), findsOneWidget);
      expect(find.text('CENTRO - RUA TRAVESSA MAJOR LAGE'), findsOneWidget);
      expect(find.text('ABÓBORAS'), findsNothing);
    });

    testWidgets('should show an empty state message if no neighborhoods are found', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget(child: const ColetaTela()));

      // Digita um termo que não corresponde a nenhum bairro.
      await tester.enterText(find.byType(TextField), 'bairro inexistente');
      await tester.pump();

      // Verifica se a mensagem de "Nenhum bairro encontrado" é exibida.
      expect(find.text('Nenhum bairro encontrado'), findsOneWidget);
    });
  });
}