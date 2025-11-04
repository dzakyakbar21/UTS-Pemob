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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
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
      body: Container(
        width: double.infinity,
        color: colorScheme.surface, // Ganti background sesuai tema aktif
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.quiz, size: 100, color: colorScheme.primary),
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
                        onPressed: () {
                          if (_nameController.text.isEmpty) return;
                          final quiz = context.read<QuizProvider>();
                          quiz.setUserName(_nameController.text);
                          quiz.resetQuiz();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizPage(userName: _nameController.text),
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
    );
  }
}
