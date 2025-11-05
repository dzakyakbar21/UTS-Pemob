import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  int _currentIndex = 0;
  bool _isFinished = false;
  String _userName = '';

  final List<int?> _selected = List<int?>.filled(techQuestions.length, null);

  int get currentIndex => _currentIndex;
  bool get isFinished => _isFinished;
  String get userName => _userName;
  int get totalQuestions => techQuestions.length;

  Question get currentQuestion => techQuestions[_currentIndex];
  int? get selectedForCurrent => _selected[_currentIndex];
  List<int?> get selectedAll => _selected;

  int get score {
    int s = 0;
    for (int i = 0; i < totalQuestions; i++) {
      if (_selected[i] != null && _selected[i] == techQuestions[i].correctIndex) s++;
    }
    return s;
  }

  // === Tambahan utility ===
  List<int> get unansweredIndices {
    final list = <int>[];
    for (int i = 0; i < totalQuestions; i++) {
      if (_selected[i] == null) list.add(i);
    }
    return list;
  }

  bool get allAnswered => unansweredIndices.isEmpty;

  int? get firstUnansweredIndex {
    for (int i = 0; i < totalQuestions; i++) {
      if (_selected[i] == null) return i;
    }
    return null;
  }

  void goTo(int index) {
    if (index < 0 || index >= totalQuestions) return;
    _currentIndex = index;
    _isFinished = false;
    notifyListeners();
  }

  void finish() {
    _isFinished = true;
    notifyListeners();
  }
  // =========================

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void select(int optionIndex) {
    _selected[_currentIndex] = optionIndex;
    notifyListeners();
  }

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

  void resetQuiz() {
    _currentIndex = 0;
    _isFinished = false;
    for (int i = 0; i < _selected.length; i++) {
      _selected[i] = null;
    }
    notifyListeners();
  }
}
