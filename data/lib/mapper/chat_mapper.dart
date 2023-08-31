import 'package:data/entities/firebase_chat.dart';
import 'package:domain/domain.dart';

import 'message_mapper.dart';

class ChatMapper {
  static Chat mapFromFirebase(FirebaseChat firebaseChat) {
    return Chat(
      uuid: firebaseChat.uuid,
      receiverUuid: firebaseChat.receiverUuid,
      senderUuid: firebaseChat.senderUuid,
      lastMessage: firebaseChat.lastMessage != null
          ? MessageMapper.mapFromFirebase(firebaseChat.lastMessage!)
          : null,
    );
  }

  static FirebaseChat mapToFirebase(Chat chat) {
    return FirebaseChat(
      uuid: chat.uuid,
      receiverUuid: chat.receiverUuid,
      senderUuid: chat.senderUuid,
      lastMessage: chat.lastMessage != null
          ? MessageMapper.mapToFirebase(chat.lastMessage!)
          : null,
    );
  }
}
