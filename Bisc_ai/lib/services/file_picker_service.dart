import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerService {
  final CollectionReference<Map<String, dynamic>> _fileTrackingCollection =
      FirebaseFirestore.instance.collection('file_tracking');

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // You can adjust the file type as needed
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;
      debugPrint('Selected file: $filePath');

      // Track the file pick event in Firestore
      _trackFilePickEvent();

      return filePath;
    } else {
      return null;
    }
  }

  Future<void> _trackFilePickEvent() async {
    try {
      // Increment the counter in Firestore
      await _fileTrackingCollection
          .doc('pick_file_counter')
          .set({'count': FieldValue.increment(1)},
              SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error tracking file pick event: $e');
    }
  }
}

