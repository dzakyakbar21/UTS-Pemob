import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'home_page.dart';
import '../models/question_model.dart';

class ResultPage extends StatelessWidget {
  final String userName;
  final int score;
  const ResultPage({super.key, required this.userName, required this.score});

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizProvider>();
    final total = quiz.totalQuestions;
    final selected = quiz.selectedAll;

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Kuis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Text('Selamat, $userName!',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Skor: $score / $total',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Review semua pertanyaan + kunci jawaban
          ...List.generate(techQuestions.length, (i) {
            final Question q = techQuestions[i];
            final int correctIdx = q.correctIndex;
            final int? userIdx = selected[i];

            final bool isCorrect = (userIdx != null && userIdx == correctIdx);
            final userText = userIdx == null
                ? 'Belum menjawab'
                : q.options[userIdx];
            final correctText = q.options[correctIdx];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soal ${i + 1}',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(q.text,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Jawaban kamu: $userText',
                      style: TextStyle(
                        color: isCorrect
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                    Text('Jawaban benar: $correctText'),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              quiz.resetQuiz();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (_) => false,
              );
            },
            child: const Text('Main Lagi'),
          ),
        ],
      ),
    );
  }
}
