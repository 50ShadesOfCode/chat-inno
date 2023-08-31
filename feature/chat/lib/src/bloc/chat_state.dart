import 'package:core/core.dart';
import 'package:domain/domain.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final String receiverUuid;
  final String chatUuid;
  final String senderUuid;
  final User sender;
  final User receiver;

  ChatState({
    required this.senderUuid,
    required this.chatUuid,
    required this.receiverUuid,
    required this.messages,
    required this.sender,
    required this.receiver,
  });

  ChatState copyWith({
    String? senderUuid,
    String? receiverUuid,
    String? chatUuid,
    List<Message>? messages,
    User? sender,
    User? receiver,
  }) {
    return ChatState(
      senderUuid: senderUuid ?? this.senderUuid,
      chatUuid: chatUuid ?? this.chatUuid,
      receiverUuid: receiverUuid ?? this.receiverUuid,
      messages: messages ?? this.messages,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
    );
  }

  @override
  List<Object> get props => <Object>[
        senderUuid,
        chatUuid,
        receiverUuid,
        messages,
      ];
}
