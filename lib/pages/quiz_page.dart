import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/question_card.dart';
import 'result_page.dart';

class QuizPage extends StatelessWidget {
  final String userName;
  const QuizPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    if (quiz.isFinished) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPage(userName: userName, score: quiz.score),
          ),
        );
      });
    }

    return WillPopScope(
      onWillPop: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Keluar dari kuis?'),
            content: const Text('Progres akan direset.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
            ],
          ),
        );
        if (ok == true) context.read<QuizProvider>().resetQuiz();
        return ok ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kuis Teknologi'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Toggle Light/Dark',
              onPressed: () => context.read<ThemeProvider>().toggle(),
              icon: const Icon(Icons.brightness_6),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              QuestionCard(quiz: quiz),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: quiz.currentIndex > 0 ? () => quiz.prev() : null,
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Sebelumnya'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => quiz.next(),
                      icon: const Icon(Icons.chevron_right),
                      label: Text(
                        quiz.currentIndex == quiz.totalQuestions - 1 ? 'Selesai' : 'Berikutnya',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
