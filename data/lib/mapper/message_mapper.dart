import 'package:data/entities/firebase_message.dart';
import 'package:domain/domain.dart';

class MessageMapper {
  static Message mapFromFirebase(FirebaseMessage firebaseMessage) {
    return Message(
      chatUuid: firebaseMessage.chatUuid,
      senderUuid: firebaseMessage.senderUuid,
      text: firebaseMessage.text,
      sendTime: firebaseMessage.sendTime,
      files: firebaseMessage.files,
    );
  }

  static FirebaseMessage mapToFirebase(Message message) {
    return FirebaseMessage(
      chatUuid: message.chatUuid,
      senderUuid: message.senderUuid,
      text: message.text,
      sendTime: message.sendTime,
      files: message.files,
    );
  }
}
