import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itaurb_transparente/controllers/favorites_provider.dart';

void main() {
  group('FavoritesProvider', () {
    late FavoritesProvider provider;

    setUp(() async {
      // Armazena em memória (sem mexer no disco) um estado inicial
      SharedPreferences.setMockInitialValues({
        'bairros_favoritos': ['CENTRO'],
      });

      provider = FavoritesProvider();
      await provider.loadFavorites();
    });

    test('carrega favoritos do SharedPreferences ao iniciar', () {
      expect(provider.isFavorite('CENTRO'), isTrue);
      expect(provider.isFavorite('ABÓBORAS'), isFalse);
    });

    test('toggle de novo favorito (liga) e persiste', () async {
      await provider.toggleFavorite('ABÓBORAS');

      expect(provider.isFavorite('ABÓBORAS'), isTrue);

      // (opcional) confirma persistência
      final prefs = await SharedPreferences.getInstance();
      final lista = prefs.getStringList('bairros_favoritos') ?? [];
      expect(lista.contains('ABÓBORAS'), isTrue);
    });

    test('toggle de favorito existente (desliga) e persiste', () async {
      await provider.toggleFavorite('CENTRO');

      expect(provider.isFavorite('CENTRO'), isFalse);

      // (opcional) confirma persistência
      final prefs = await SharedPreferences.getInstance();
      final lista = prefs.getStringList('bairros_favoritos') ?? [];
      expect(lista.contains('CENTRO'), isFalse);
    });
  });
}
