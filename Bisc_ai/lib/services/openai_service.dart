import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String baseURL =
      'https://api.openai.com/v1/engines/gpt-3.5-turbo-instruct-0914/completions';
  final String? apiKey = dotenv.env['OPENAI_API_KEY'];

  Future<String> fetchResponse(String prompt,
      {int maxTokens = 150,
      double temperature = 0.7,
      int topP = 1,
      int frequencyPenalty = 0,
      int presencePenalty = 0}) async {
    var headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    var body = json.encode({
      'prompt': prompt,
      'max_tokens': maxTokens,
      'temperature': temperature,
      // 'top_p': topP,
      // 'frequency_penalty': frequencyPenalty,
      // 'presence_penalty': presencePenalty
    });

    var response = await http.post(
      Uri.parse(baseURL),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['choices'][0]['text'];
    } else {
      throw Exception('Failed to fetch from OpenAI API');
    }
  }
}
