import 'firebase_message.dart';

class FirebaseChat {
  final String uuid;
  final String receiverUuid;
  final String senderUuid;
  final FirebaseMessage? lastMessage;

  FirebaseChat({
    required this.uuid,
    required this.receiverUuid,
    required this.senderUuid,
    this.lastMessage,
  });

  factory FirebaseChat.fromJson(Map<String, dynamic> data) {
    return FirebaseChat(
      uuid: data['uuid'] ?? '',
      receiverUuid: data['receiver_uuid'],
      senderUuid: data['sender_uuid'],
      lastMessage: data['last_message'] != null
          ? FirebaseMessage.fromJson(
              data['last_message'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'receiver_uuid': receiverUuid,
      'sender_uuid': senderUuid,
      'last_message': lastMessage?.toJson(),
    };
  }
}
