import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // tap di luar menutup keyboard
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tech Quiz'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Ganti Tema',
              onPressed: () => context.read<ThemeProvider>().toggle(),
              icon: const Icon(Icons.brightness_6),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.quiz,
                            size: 100, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Selamat Datang di Kuis Teknologi!',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Masukkan nama kamu',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_nameController.text.isEmpty) return;

                              // 1) Tutup keyboard
                              FocusScope.of(context).unfocus();
                              // 2) Beri jeda kecil agar keyboard benar-benar turun (hindari flicker/overflow)
                              await Future.delayed(const Duration(milliseconds: 180));

                              // 3) Set nama, reset quiz, lalu navigasi (fade)
                              final quiz = context.read<QuizProvider>();
                              quiz.setUserName(_nameController.text);
                              quiz.resetQuiz();

                              // Transisi fade agar halus
                              // (pushReplacement agar Home tidak menumpuk di stack)
                              // ignore: use_build_context_synchronously
                              await Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 250),
                                  pageBuilder: (_, __, ___) =>
                                      QuizPage(userName: _nameController.text),
                                  transitionsBuilder: (_, anim, __, child) =>
                                      FadeTransition(opacity: anim, child: child),
                                ),
                              );
                            },
                            child: const Text('Mulai Kuis'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
