import 'dart:io';

class SendMessageRequest {
  final String chatUuid;
  final String receiverUuid;
  final String text;
  final List<File> files;

  SendMessageRequest({
    required this.chatUuid,
    required this.receiverUuid,
    required this.text,
    required this.files,
  });
}
