import 'dart:async';
import 'dart:io';
import '../models/question.dart';
import '../services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';

import '../models/score_model.dart';
import '../models/transcript.dart';
import '../models/transcript_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionIndex = 0;

  void incrementQuestionIndex() {
    setState(() {
      _questionIndex = (_questionIndex + 1) % 5;
      if (_questionIndex == 0) {
        // Ran out of questions and need to generate more
        _questions = [];
        generateQuestions();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    generateQuestions();
    _createBannerAd();
  }

  BannerAd? _banner;

  void _createBannerAd() {
    _banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Replace with your ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BannerAdWidget(ad: _banner), // Display banner ad at the top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ScoreChips(),
                const SizedBox(height: 32),
                _questions.isNotEmpty
                    ? QuestionView(
                        question: _questions[_questionIndex],
                        incrementQuestionIndex: incrementQuestionIndex)
                    : const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ],
    );
  }


  void generateQuestions() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Transcript transcript =
          Provider.of<TranscriptModel>(context, listen: false).transcript;
      _getResponse(transcript.text);
    });
  }

  final OpenAIService _service = OpenAIService();
  String _responseText = '';
  List<Question> _questions = [];

  Future<String> _loadTranscriptAsset(String filePath) async {
    try {
      final file = File(filePath);

      // Read the file
      return await file.readAsString();
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  List<Question> parseQuestions(String responseText) {
    var lines = responseText.split('\n');
    List<Question> questions = [];
    if (SetQuestionType == 0) {
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains(RegExp(r'^\d+\:'))) {
          String questionText =
              lines[i].substring(lines[i].indexOf(':') + 1).trim();
          List<Answer> answers = [];
          int correctIndex = -1;

          while (i + 1 < lines.length &&
              (lines[i + 1].contains(RegExp(r'^[a-d]\)')) ||
                  lines[i + 1].startsWith('CORRECT: Option '))) {
            i++;

            if (lines[i].startsWith('CORRECT: Option ')) {
              correctIndex = 'abcd'.indexOf(lines[i][16]);
            } else {
              String answerText = lines[i].substring(3).trim();
              answers.add(Answer(
                  text: answerText,
                  isCorrect: false)); // Temporarily set isCorrect to false
            }
          }

          if (correctIndex != -1 && correctIndex < answers.length) {
            answers[correctIndex].isCorrect =
                true; // Set the correct answer after parsing all options
          }

          questions.add(Question(text: questionText, answers: answers));
        }
      }
    }
    if (SetQuestionType == 1) {
      for (int i = 0; i < lines.length - 2; i++) {
        if (lines[i].contains('?')) {
          String q = lines[i];
          String a = (lines[i + 3].split(':'))[1].trim();
          List<Answer> answers = [];
        
          answers.add(Answer(
          text: a,
          isCorrect: true));

          if (a == 'True') {
            answers.add(Answer(
            text: 'False',
            isCorrect: false));
          } else {
            answers.add(Answer(
            text: 'True',
            isCorrect: false));
          }
          questions.add(Question(text: q, answers: answers));
          }
      }
    }
    return questions;
  }

  void _getResponse(String transcript) async {
    try {
      String prompt = '-';
      if (SetQuestionType == 0) {
        prompt = 'Following is a lecture transcript. \n \n Given this transcript, generate 5 multiple-choice questions and their correct answers. \n\n Answer with ONLY the questions, their correct answers, and their choices. For each question, write your response in the following format:\n\n1: Question text.\na) Option 1a b)\nOption 1b\nc) Option 1c\nd) Option 1d\nCORRECT: Option a\n\n Transcript: $transcript';
      }
      if (SetQuestionType == 1) {
        prompt = 'Following is a lecture transcript. \n \n Given this transcript, generate 5 True False questions and their correct answers. \n\n Answer with ONLY the questions, their correct answers, and their choices. For each question, write your response in the following format:\n\n1: Question text.\n True \n False \nCORRECT: answere\n\n Transcript: $transcript';
      }
          
      String response = await _service.fetchResponse(
        prompt,
        maxTokens: 2000,
        temperature: 0.3,
      );
      // print('response fetched');
      setState(() {
        _responseText = response;
        // print(_responseText);
        _questions = parseQuestions(_responseText);
        // for (var i = 0; i < _questions.length; i++) {
        //   print('Q$i');
        //   for (var j = 0; j < _questions[i].answers.length; j++) {
        //     print(_questions[i].answers[j].isCorrect);
        //   }
        // }
      });
    } catch (e) {
      print(e.toString());
    }
  }

}

class ScoreChips extends StatelessWidget {
  const ScoreChips({super.key});

  @override
  Widget build(BuildContext context) {
    var score = context.watch<ScoreModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Chip(
            avatar: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            label: Text('${score.correctScore}')),
        const SizedBox(width: 32),
        Chip(
            avatar: const Icon(Icons.close, color: Colors.red),
            label: Text('${score.incorrectScore}'))
      ],
    );
  }
}

class QuestionText extends StatelessWidget {
  const QuestionText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class AnswerList extends StatefulWidget {
  AnswerList({
    required this.answers,
  }) : super(key: ObjectKey(answers));

  final List<Answer> answers;

  @override
  State<AnswerList> createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  bool _isAnswered = false;

  void setAnswered(bool isAnswered) {
    setState(() {
      _isAnswered = isAnswered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (ctx, i) => const SizedBox(height: 10),
        shrinkWrap: true,
        itemCount: widget.answers.length,
        itemBuilder: (ctx, i) => AnswerItem(
            answer: widget.answers[i],
            setAnswered: setAnswered,
            enabled: !_isAnswered));
  }
}

class AnswerItem extends StatefulWidget {
  const AnswerItem(
      {super.key,
      required this.answer,
      required this.setAnswered,
      required this.enabled});

  final Answer answer;
  final Function(bool) setAnswered;
  final bool enabled;

  @override
  State<AnswerItem> createState() => _AnswerItemState();
}

class _AnswerItemState extends State<AnswerItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    var score = context.watch<ScoreModel>();

    return ElevatedButton(
        onPressed: () {
          setState(() {
            _pressed = true;
          });

          widget.setAnswered(true);

          if (widget.enabled) {
            if (widget.answer.isCorrect) {
              score.addToCorrectScore(1);
            } else {
              score.addToIncorrectScore(1);
            }
          }

          debugPrint(
              'ElevatedButton pressed, text: ${widget.answer.text}, isCorrect: ${widget.answer.isCorrect}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: !widget.enabled
              ? (widget.answer.isCorrect ? Colors.green[50] : Colors.red[50])
              : Theme.of(context).buttonTheme.colorScheme?.background,
        ),
        child: Text(widget.answer.text,
            style: TextStyle(
              color: widget.enabled
                  ? Theme.of(context).buttonTheme.colorScheme?.primary
                  : Colors.grey[800],
            )));
  }
}

class NextQuestionButton extends StatelessWidget {
  const NextQuestionButton({super.key, required this.incrementQuestionIndex});

  final VoidCallback incrementQuestionIndex;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        incrementQuestionIndex();
      },
      icon: const Icon(Icons.arrow_forward),
      label: const Text('Next'),
    );
  }
}

class QuestionView extends StatefulWidget {
  final Question question;
  const QuestionView(
      {super.key,
      required this.question,
      required this.incrementQuestionIndex});

  final VoidCallback incrementQuestionIndex;

  @override
  State<StatefulWidget> createState() => _QuestionView();
}

class _QuestionView extends State<QuestionView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuestionText(text: widget.question.text),
        const SizedBox(height: 20),
        AnswerList(answers: widget.question.answers),
        const SizedBox(height: 36),
        NextQuestionButton(
            incrementQuestionIndex: widget.incrementQuestionIndex),
      ],
    );
  }
}

class BannerAdWidget extends StatelessWidget {
  final BannerAd? ad;

  const BannerAdWidget({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ad == null) {
      return Container(); // Return an empty container if the ad is null
    }

    return Container(
      width: ad?.size.width.toDouble() ?? 0.0, // Use null-aware operator
      height: ad?.size.height.toDouble() ?? 0.0, // Use null-aware operator
      child: AdWidget(ad: ad!),
    );
  }
}

