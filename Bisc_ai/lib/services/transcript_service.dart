import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/transcript.dart';

final apiUrl = dotenv.env['API_URL'];

class TranscriptService {
  String getUserId() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      throw Exception('Could not get user id because user is not signed in.');
    }
  }

  Future<List<TranscriptResponse>> getTranscripts() async {
    final response =
        await http.get(Uri.parse('$apiUrl/users/${getUserId()}/transcripts'));

    if (response.statusCode == 200) {
      return List<TranscriptResponse>.from(
          jsonDecode(response.body).map((x) => TranscriptResponse.fromJson(x)));
    } else {
      throw Exception('Failed to get transcript.');
    }
  }

  Future<TranscriptResponse> getTranscript(String transcriptId) async {
    final response = await http.get(
        Uri.parse('$apiUrl/users/${getUserId()}/transcripts/$transcriptId'));

    if (response.statusCode == 200) {
      return TranscriptResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to get transcript.');
    }
  }

  Future<TranscriptResponse> addTranscript(Transcript transcript) async {
    final response =
        await http.post(Uri.parse('$apiUrl/users/${getUserId()}/transcripts'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'title': transcript.title,
              'text': transcript.text,
            }));

    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return TranscriptResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create transcript.');
    }
  }
}
