import 'package:cloud_firestore/cloud_firestore.dart';

class Transcript {
  final String title;
  final String text;

  Transcript({required this.title, required this.text});
}

class TranscriptRequest {
  final String title;
  final String text;

  TranscriptRequest({required this.title, required this.text});
}

class TranscriptResponse {
  final String id;
  final String userId;
  final String title;
  final DateTime dateUploaded;
  final String text;

  const TranscriptResponse(
      {required this.id,
      required this.userId,
      required this.title,
      required this.dateUploaded,
      required this.text});

  factory TranscriptResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': String id,
        'userId': String userId,
        'title': String title,
        'dateUploaded': Map<String, dynamic> dateUploaded,
        'text': String text,
      } =>
        TranscriptResponse(
          id: id,
          userId: userId,
          title: title,
          dateUploaded:
              Timestamp(dateUploaded['_seconds'], dateUploaded['_nanoseconds'])
                  .toDate(),
          text: text,
        ),
      _ => throw const FormatException('Failed to load transcript.'),
    };
  }
}
