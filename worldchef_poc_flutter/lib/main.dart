import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'routing/app_router.dart';
import 'providers/theme_provider.dart';
import 'services/theme_persistence_service.dart';

void main() {
  // Initialize router configuration
  AppRouterConfig.initialize();
  runApp(const WorldChefApp());
}

/// WorldChef PoC Flutter Application
/// 
/// Enhanced with Task F006 implementation:
/// - Provider-based theme state management with persistence
/// - Theme toggle functionality with shared_preferences storage
/// - Material Design 3 theming with dynamic color schemes
/// - GoRouter navigation between list and detail screens
/// - Type-safe parameter passing for recipe IDs
/// - Hero animation support with consistent hero tags
/// - Back navigation and deep linking support
class WorldChefApp extends StatelessWidget {
  const WorldChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(ThemePersistenceService()),
      child: const _WorldChefMaterialApp(),
    );
  }
}

/// Material app with theme provider integration
class _WorldChefMaterialApp extends StatefulWidget {
  const _WorldChefMaterialApp();

  @override
  State<_WorldChefMaterialApp> createState() => _WorldChefMaterialAppState();
}

class _WorldChefMaterialAppState extends State<_WorldChefMaterialApp> {
  @override
  void initState() {
    super.initState();
    // Initialize theme provider asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'WorldChef PoC',
          debugShowCheckedModeBanner: false,
          
          // GoRouter configuration
          routerConfig: AppRouterConfig.router,
          
          // Internationalization configuration  
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('es', ''), // Spanish
            Locale('ar', ''), // Arabic (RTL testing)
          ],
          
          // Material Design 3 theme configuration
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
            ),
          ),
          // Use theme provider's current theme mode
          themeMode: themeProvider.currentThemeMode,
        );
      },
    );
  }
} 