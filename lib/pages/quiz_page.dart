import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/question_overview_sheet.dart';
import 'result_page.dart';

class QuizPage extends StatelessWidget {
  final String userName;
  const QuizPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    // Auto ke hasil jika selesai
    if (quiz.isFinished) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResultPage(userName: userName, score: quiz.score),
          ),
        );
      });
    }

    final progress = quiz.totalQuestions == 0
        ? 0.0
        : (quiz.currentIndex + 1) / quiz.totalQuestions;

    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final sysBottom = MediaQuery.of(context).padding.bottom;

    return WillPopScope(
      onWillPop: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Keluar dari kuis?'),
            content: const Text('Progres akan direset.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ya'),
              ),
            ],
          ),
        );

        if (ok == true) context.read<QuizProvider>().resetQuiz();
        return ok ?? false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Kuis Teknologi'),
          centerTitle: true,
          leading: IconButton(
            tooltip: 'Daftar Soal',
            onPressed: () => showQuestionOverviewSheet(context),
            icon: const Icon(Icons.view_module),
          ),
          actions: [
            IconButton(
              tooltip: 'Toggle Light/Dark',
              onPressed: () => context.read<ThemeProvider>().toggle(),
              icon: const Icon(Icons.brightness_6),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(28),
            child: Column(
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Text(
                  'Terjawab ${quiz.totalQuestions - quiz.unansweredIndices.length} / ${quiz.totalQuestions}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),

        body: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: viewInsets > 0 ? viewInsets : sysBottom,
          ),

          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuestionCard(quiz: quiz),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: quiz.currentIndex > 0
                              ? () => quiz.prev()
                              : null,
                          icon: const Icon(Icons.chevron_left),
                          label: const Text('Sebelumnya'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final isLast =
                                quiz.currentIndex ==
                                    quiz.totalQuestions - 1;

                            // Jika terakhir, cek semua soal terjawab
                            if (isLast) {
                              if (!quiz.allAnswered) {
                                final firstEmpty =
                                    quiz.firstUnansweredIndex!;
                                
                                context
                                    .read<QuizProvider>()
                                    .goTo(firstEmpty);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Masih ada soal yang belum dijawab. Mengarahkan ke soal ${firstEmpty + 1}.',
                                    ),
                                    duration:
                                        const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }

                              // Semua soal terjawab, selesaikan kuis
                              context.read<QuizProvider>().finish();
                              return;
                            }

                            // Jika bukan terakhir, lanjutkan
                            context.read<QuizProvider>().next();
                          },
                          icon: const Icon(Icons.chevron_right),
                          label: Text(
                            quiz.currentIndex ==
                                    quiz.totalQuestions - 1
                                ? 'Selesai'
                                : 'Berikutnya',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
