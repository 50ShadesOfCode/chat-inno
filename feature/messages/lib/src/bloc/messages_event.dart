import 'package:flutter/foundation.dart';

@immutable
abstract class MessagesEvent {}

class InitEvent extends MessagesEvent {}

class OpenChatEvent extends MessagesEvent {
  final String chatUuid;
  final String receiverUuid;

  OpenChatEvent({
    required this.chatUuid,
    required this.receiverUuid,
  });
}

class NewChatEvent extends MessagesEvent {
  final String uuid;

  NewChatEvent({
    required this.uuid,
  });
}
