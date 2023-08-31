import 'package:domain/domain.dart';

abstract class ChatRepository {
  Future<void> createChat(String uuid);

  Future<void> sendMessage(SendMessageRequest request);

  Stream<List<Message>> getMessagesStreamByChatId(String uuid);

  Future<void> deleteChat(String uuid);

  Stream<Chat> getChatStream(String uuid);
}
