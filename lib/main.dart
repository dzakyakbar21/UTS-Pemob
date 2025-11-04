import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'providers/quiz_provider.dart';
import 'providers/theme_provider.dart';
import 'pages/splash_page.dart';

void main() => runApp(const UTSLabApp());

class UTSLabApp extends StatelessWidget {
  const UTSLabApp({super.key});

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
            title: 'UTS Lab Quiz',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProv.mode,
            home: const SplashPage(), // <<— start dari Splash
          );
        },
      ),
    );
  }
}
