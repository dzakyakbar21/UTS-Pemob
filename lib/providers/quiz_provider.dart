import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  int _currentIndex = 0;
  bool _isFinished = false;
  String _userName = '';

  // Simpan pilihan user per-pertanyaan (null artinya belum memilih)
  final List<int?> _selected = List<int?>.filled(techQuestions.length, null);

  // ===== Getters =====
  int get currentIndex => _currentIndex;
  bool get isFinished => _isFinished;
  String get userName => _userName;
  Question get currentQuestion => techQuestions[_currentIndex];
  int get totalQuestions => techQuestions.length;

  List<int?> get selectedAll => _selected;
  int? get selectedForCurrent => _selected[_currentIndex];
  int get correctIndexForCurrent => currentQuestion.correctIndex;

  int get score {
    int s = 0;
    for (int i = 0; i < totalQuestions; i++) {
      final sel = _selected[i];
      if (sel != null && sel == techQuestions[i].correctIndex) s++;
    }
    return s;
  }

  // ===== Setters / actions =====
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // memilih opsi TAPI tidak otomatis pindah
  void select(int optionIndex) {
    _selected[_currentIndex] = optionIndex;
    notifyListeners();
  }

  // navigasi
  void next() {
    if (_currentIndex < totalQuestions - 1) {
      _currentIndex++;
    } else {
      _isFinished = true;
    }
    notifyListeners();
  }

  void prev() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _isFinished = false;
    }
    notifyListeners();
  }

  // helper untuk teks jawaban
  String? get userAnswerText {
    final sel = selectedForCurrent;
    if (sel == null) return null;
    return currentQuestion.options[sel];
    }
  String get correctAnswerText => currentQuestion.options[correctIndexForCurrent];

  // reset full sesi
  void resetQuiz() {
    _currentIndex = 0;
    _isFinished = false;
    for (int i = 0; i < _selected.length; i++) {
      _selected[i] = null;
    }
    notifyListeners();
  }
}
