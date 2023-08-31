import 'package:core/core.dart';

class Message extends Equatable {
  final String chatUuid;
  final String senderUuid;
  final String text;
  final DateTime sendTime;
  final List<String> files;

  const Message({
    required this.chatUuid,
    required this.senderUuid,
    required this.text,
    required this.sendTime,
    required this.files,
  });

  @override
  List<Object> get props => <Object>[
        files,
        chatUuid,
        senderUuid,
        text,
        sendTime,
      ];
}
