import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/quiz_provider.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProv.mode,

            // ⛔️ JANGAN pakai `home:` di sini
            // ✅ Pakai initialRoute + routes agar Splash SELALU jadi rute pertama
            initialRoute: '/splash',
            routes: {
              '/splash': (_) => const SplashPage(),
              '/home':   (_) => const HomePage(),
            },

            // (opsional) cegah route lain jadi default
            onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const SplashPage()),
          );
        },
      ),
    );
  }
}
