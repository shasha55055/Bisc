import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum QuestionType { MultipleChoice, TrueFalse }

var SetQuestionType = 0;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  QuestionType? selectedQuestionType = QuestionType.MultipleChoice;

  void _showQuestionTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Question Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<QuestionType>(
                title: const Text('Multiple Choice'),
                value: QuestionType.MultipleChoice,
                groupValue: selectedQuestionType,
                onChanged: (QuestionType? value) {
                  setState(() {
                    selectedQuestionType = value;
                  });
                  SetQuestionType = 0;
                  Navigator.pop(context); // Close the dialog after selection
                },
              ),
              RadioListTile<QuestionType>(
                title: const Text('True or False'),
                value: QuestionType.TrueFalse,
                groupValue: selectedQuestionType,
                onChanged: (QuestionType? value) {
                  setState(() {
                    selectedQuestionType = value;
                  });
                  SetQuestionType = 1;
                  Navigator.pop(context); // Close the dialog after selection
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Question Type'),
          subtitle: Text(selectedQuestionType == QuestionType.MultipleChoice
              ? 'Multiple Choice'
              : 'True or False'),
          onTap: () {
            _showQuestionTypeDialog();
          },
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    context.go('/auth');
                  }
                },
                child: const Text('Sign out')))
      ],
    );
  }
}
