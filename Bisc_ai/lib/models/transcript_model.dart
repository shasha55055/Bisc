import 'transcript.dart';
import 'package:flutter/foundation.dart';

class TranscriptModel extends ChangeNotifier {
  Transcript _transcript = Transcript(title: '', text: '');

  set transcript(Transcript transcript) {
    _transcript = transcript;
    notifyListeners();
  }

  Transcript get transcript {
    return _transcript;
  }
}
