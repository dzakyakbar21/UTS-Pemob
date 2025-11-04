class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

final List<Question> techQuestions = [
  Question(
    text: 'Siapa pencipta bahasa pemrograman Python?',
    options: ['Guido van Rossum', 'Dennis Ritchie', 'Bjarne Stroustrup', 'James Gosling'],
    correctIndex: 0,
  ),
  Question(
    text: 'Android dikembangkan oleh perusahaan mana?',
    options: ['Google', 'Apple', 'Microsoft', 'Samsung'],
    correctIndex: 0,
  ),
  Question(
    text: 'HTML digunakan untuk?',
    options: ['Membuat tampilan web', 'Mengatur database', 'Menjalankan server', 'Menangani request API'],
    correctIndex: 0,
  ),
];
