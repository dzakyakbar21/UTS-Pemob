import 'package:flutter/material.dart';
import '../providers/quiz_provider.dart';
import 'answer_button.dart';

class QuestionCard extends StatelessWidget {
  final QuizProvider quiz;
  const QuestionCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final q = quiz.currentQuestion;
    final selected = quiz.selectedForCurrent; // int? (null jika belum pilih)

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertanyaan ${quiz.currentIndex + 1} / ${quiz.totalQuestions}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(q.text, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...List.generate(
              q.options.length,
              (i) => AnswerButton(
                text: q.options[i],
                isSelected: selected == i,
                onPressed: () => quiz.select(i),
              ),
            ),
            // >>> Tidak menampilkan "Jawaban kamu" lagi di sini <<<
          ],
        ),
      ),
    );
  }
}
