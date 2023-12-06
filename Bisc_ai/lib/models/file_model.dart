import 'package:flutter/foundation.dart';

class FileModel extends ChangeNotifier {
  String? _uploadedFilePath;

  set uploadedFilePath(String? uploadedFilePath) {
    _uploadedFilePath = uploadedFilePath;
    notifyListeners();
  }

  String? get uploadedFilePath {
    return _uploadedFilePath;
  }
}
