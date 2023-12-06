import 'dart:io';

import '../models/transcript.dart';
import '../services/file_picker_service.dart';
import '../services/transcript_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

import '../models/transcript_model.dart';

class TranscriptListTile extends StatelessWidget {
  final TranscriptResponse transcriptListItem;

  const TranscriptListTile({super.key, required this.transcriptListItem});

  @override
  Widget build(BuildContext context) {
    var transcriptModel = context.watch<TranscriptModel>();

    return Material(
        type: MaterialType.transparency,
        child: ListTile(
          onTap: () {
            TranscriptService transcriptService = TranscriptService();
            transcriptService
                .getTranscript(transcriptListItem.id)
                .then((response) {
              transcriptModel.transcript = Transcript(
                  title: transcriptListItem.title, text: response.text);
              context.go('/quiz');
            });
          },
          title: Text(transcriptListItem.title),
          subtitle: Text(timeago.format(transcriptListItem.dateUploaded)),
          trailing: const Icon(Icons.play_arrow),
        ));
  }
}

class TranscriptListScreen extends StatefulWidget {
  const TranscriptListScreen({super.key});

  @override
  State<TranscriptListScreen> createState() => _TranscriptListScreenState();
}

class _TranscriptListScreenState extends State<TranscriptListScreen> {
  TranscriptService transcriptService = TranscriptService();

  @override
  Widget build(BuildContext context) {
    var transcriptModel = context.watch<TranscriptModel>();

    return FutureBuilder<List<TranscriptResponse>>(
        future: transcriptService.getTranscripts(),
        builder: (context, AsyncSnapshot<List<TranscriptResponse>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return Stack(alignment: Alignment.bottomRight, children: [
              ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Container(
                      color: index % 2 == 0
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.01),
                      child: TranscriptListTile(
                          transcriptListItem: snapshot.data![index]))),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FloatingActionButton(
                  onPressed: () {
                    FilePickerService filePickerService = FilePickerService();

                    filePickerService.pickFile().then((filePath) {
                      try {
                        final file = File(filePath!);

                        // Read the file
                        file.readAsString().then((text) {
                          var uuid = const Uuid();
                          Transcript transcript = Transcript(
                              title: file.uri.pathSegments.last, text: text);
                          TranscriptService transcriptService =
                              TranscriptService();
                          transcriptService
                              .addTranscript(transcript)
                              .then((id) {
                            transcriptModel.transcript = transcript;
                            context.go('/quiz');
                          });
                        });
                      } catch (e) {
                        // If encountering an error, return 0
                        return '';
                      }
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              )
            ]);
          } else {
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
                        onPressed: () {
                          FilePickerService filePickerService =
                              FilePickerService();

                          filePickerService.pickFile().then((filePath) {
                            try {
                              final file = File(filePath!);

                              // Read the file
                              file.readAsString().then((text) {
                                var uuid = const Uuid();
                                Transcript transcript = Transcript(
                                    title: file.uri.pathSegments.last,
                                    text: text);
                                TranscriptService transcriptService =
                                    TranscriptService();
                                transcriptService
                                    .addTranscript(transcript)
                                    .then((id) {
                                  transcriptModel.transcript = transcript;
                                  context.go('/quiz');
                                });
                              });
                            } catch (e) {
                              // If encountering an error, return 0
                              return '';
                            }
                          });
                        },
                        child: const Text('Upload'),
                      ),
                    ]),
                  )
                ],
              ),
            );
          }
        });
  }
}
