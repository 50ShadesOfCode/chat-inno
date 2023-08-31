import 'package:core/core.dart';

import 'message.dart';

class Chat extends Equatable {
  const Chat({
    required this.uuid,
    required this.receiverUuid,
    required this.senderUuid,
    this.lastMessage,
  });

  final String uuid;

  final Message? lastMessage;

  final String receiverUuid;

  final String senderUuid;

  @override
  List<Object?> get props => <Object?>[
        uuid,
        lastMessage,
        receiverUuid,
        senderUuid,
      ];
}
