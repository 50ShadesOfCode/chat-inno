class FirebaseMessage {
  final String text;
  final String chatUuid;
  final String senderUuid;
  final DateTime sendTime;
  final List<String> files;

  FirebaseMessage({
    required this.files,
    required this.chatUuid,
    required this.senderUuid,
    required this.text,
    required this.sendTime,
  });

  factory FirebaseMessage.fromJson(Map<String, dynamic> data) {
    return FirebaseMessage(
      files: (data['files'] as List<dynamic>)
          .map((dynamic element) => element as String)
          .toList(),
      chatUuid: data['chat_uuid'],
      senderUuid: data['sender_uuid'],
      text: data['text'],
      sendTime: DateTime.parse(data['send_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'chat_uuid': chatUuid,
      'sender_uuid': senderUuid,
      'text': text,
      'send_time': sendTime.toIso8601String(),
      'files': files,
    };
  }
}
