// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itaurb_transparente/providers/favorites_provider.dart';
import 'package:itaurb_transparente/providers/theme_provider.dart';
import 'package:itaurb_transparente/services/data_cache_service.dart';
import 'package:itaurb_transparente/services/notification_service.dart';
import 'package:itaurb_transparente/telas/home_tela.dart';
import 'package:itaurb_transparente/telas/onboarding_tela.dart';
import 'package:itaurb_transparente/telas/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- PALETA DE CORES ---
const itaurbBlue = Color(0xFF5C9DD5);
const itaurbYellow = Color(0xFFFFC107);
const itaurbDarkText = Color(0xFF333333);
const itaurbLightText = Color(0xFF757575);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final lightTheme = ThemeData(
              primaryColor: itaurbBlue,
              scaffoldBackgroundColor: Colors.grey[50],
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: itaurbBlue, primary: itaurbBlue, secondary: itaurbYellow, brightness: Brightness.light),
              appBarTheme: AppBarTheme(backgroundColor: itaurbBlue, foregroundColor: Colors.white, elevation: 1, titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
              cardTheme: CardThemeData(elevation: 1.5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: itaurbBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(bodyColor: itaurbLightText, displayColor: itaurbDarkText),
              useMaterial3: true,
              segmentedButtonTheme: SegmentedButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.w500)))));
          final darkTheme = ThemeData(
              primaryColor: itaurbBlue,
              scaffoldBackgroundColor: const Color(0xFF121212),
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(seedColor: itaurbBlue, primary: itaurbBlue, secondary: itaurbYellow, brightness: Brightness.dark),
              appBarTheme: AppBarTheme(backgroundColor: const Color(0xFF1E1E1E), foregroundColor: Colors.white, elevation: 1, titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
              cardTheme: CardThemeData(color: const Color(0xFF1E1E1E), elevation: 1.5, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: itaurbBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(bodyColor: Colors.white70, displayColor: Colors.white),
              useMaterial3: true,
              segmentedButtonTheme: SegmentedButtonThemeData(
                  style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) { return itaurbBlue; }
                  return Colors.grey.shade800;
                }),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                textStyle: MaterialStateProperty.all(const TextStyle(fontWeight: FontWeight.w500)),
              )));
          return MaterialApp(
            title: 'Itaurb Transparente',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});
  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<bool> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  Future<bool> _initializeApp() async {
    // Chama o serviço de cache para carregar os dados
    await DataCacheService.instance.initialize();
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Erro ao iniciar o app:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          final hasSeenOnboarding = snapshot.data!;
          return hasSeenOnboarding
              ? const HomeTela()
              : const OnboardingTela();
        }
        return const SplashScreen();
      },
    );
  }
}