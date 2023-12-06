import '../models/file_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String? _filePath;

  Future<String?> _pickAndUploadFile(FileModel fileModel) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // You can adjust the file type as needed
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.path;
      });
      debugPrint('Selected file: $_filePath');
      fileModel.uploadedFilePath = _filePath!;
    } else {
      setState(() {
        _filePath = null;
      });
    }
    return _filePath;
  }

  @override
  Widget build(BuildContext context) {
    var fileModel = context.watch<FileModel>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              Text(
                'Welcome to Biscuitt, the AI study tool!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Upload your lecture transcript or notes to start generating unlimited practice questions.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () =>
                    _pickAndUploadFile(fileModel).then((String? filePath) {
                  if (filePath != null) {
                    context.go('/quiz');
                  }
                }),
                child: const Text('Upload'),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
