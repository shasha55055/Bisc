import 'package:flutter/foundation.dart';

class ScoreModel extends ChangeNotifier {
  int _correctScore = 0;
  int _incorrectScore = 0;

  void addToCorrectScore(int value) {
    _correctScore += value;
    notifyListeners();
  }

  void addToIncorrectScore(int value) {
    _incorrectScore += value;
    notifyListeners();
  }

  int get correctScore {
    return _correctScore;
  }

  int get incorrectScore {
    return _incorrectScore;
  }
}
