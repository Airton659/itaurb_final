import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itaurb_transparente/controllers/favorites_provider.dart';

void main() {
  group('FavoritesProvider', () {
    late FavoritesProvider provider;

    setUp(() async {
      // Inicia o storage em memória com um favorito já salvo
      SharedPreferences.setMockInitialValues({
        'bairros_favoritos': ['CENTRO'],
      });

      provider = FavoritesProvider();
      await provider.loadFavorites();
    });

    test('should load favorites from SharedPreferences on initialization', () {
      expect(provider.isFavorite('CENTRO'), isTrue);
      expect(provider.isFavorite('ABÓBORAS'), isFalse);
    });

    test('should toggle a new favorite on and persist it', () async {
      await provider.toggleFavorite('ABÓBORAS');
      expect(provider.isFavorite('ABÓBORAS'), isTrue);

      // (opcional) confirma persistência
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('bairros_favoritos')!.contains('ABÓBORAS'), isTrue);
    });

    test('should toggle a favorite off and persist it', () async {
      await provider.toggleFavorite('CENTRO');
      expect(provider.isFavorite('CENTRO'), isFalse);

      // (opcional) confirma persistência
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('bairros_favoritos')!.contains('CENTRO'), isFalse);
    });
  });
}
