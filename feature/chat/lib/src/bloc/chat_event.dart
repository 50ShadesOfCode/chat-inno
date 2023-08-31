import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ChatEvent {}

class InitEvent extends ChatEvent {
  final String receiverUuid;
  final String chatUuid;

  InitEvent({
    required this.chatUuid,
    required this.receiverUuid,
  });
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final List<File> files;

  SendMessageEvent({
    required this.message,
    required this.files,
  });
}

class UpdateEvent extends ChatEvent {
  final List<Message> messages;

  UpdateEvent({
    required this.messages,
  });
}

class ListenForMessagesEvent extends ChatEvent {}

class DeleteChatEvent extends ChatEvent {}
