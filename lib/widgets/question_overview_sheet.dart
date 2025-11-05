import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

Future<void> showQuestionOverviewSheet(BuildContext context) async {
  final quiz = context.read<QuizProvider>();
  final cs = Theme.of(context).colorScheme;

  await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Soal', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Terjawab ${quiz.totalQuestions - quiz.unansweredIndices.length} / ${quiz.totalQuestions}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth ~/ 56; // chip grid rapih
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount.clamp(3, 8),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: quiz.totalQuestions,
                  itemBuilder: (context, i) {
                    final isCurrent = i == quiz.currentIndex;
                    final answered = quiz.selectedAll[i] != null;
                    final bg = answered
                        ? cs.primaryContainer
                        : cs.surfaceVariant;
                    final fg = answered
                        ? cs.onPrimaryContainer
                        : cs.onSurfaceVariant;

                    return Material(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(context);
                          context.read<QuizProvider>().goTo(i);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: isCurrent
                                ? Border.all(color: cs.primary, width: 2)
                                : null,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: fg,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
