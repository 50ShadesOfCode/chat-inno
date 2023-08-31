import 'package:core/core.dart';
import 'package:data/entities/firebase_chat.dart';
import 'package:data/entities/firebase_message.dart';
import 'package:data/mapper/chat_mapper.dart';
import 'package:data/mapper/message_mapper.dart';
import 'package:data/providers/firebase_provider.dart';
import 'package:data/providers/storage_provider.dart';
import 'package:domain/domain.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseProvider _firebaseProvider;
  final StorageProvider _storageProvider;

  ChatRepositoryImpl({
    required FirebaseProvider firebaseProvider,
    required StorageProvider storageProvider,
  })  : _firebaseProvider = firebaseProvider,
        _storageProvider = storageProvider;

  @override
  Future<void> createChat(String uuid) async {
    final String localUuid = _storageProvider.getString(StorageConstants.uuid);
    final FirebaseChat chat = FirebaseChat(
      uuid: const Uuid().v4(),
      receiverUuid: uuid,
      senderUuid: localUuid,
    );
    await _firebaseProvider.createChat(chat);
  }

  @override
  Stream<List<Message>> getMessagesStreamByChatId(String uuid) async* {
    await for (final QuerySnapshot<Map<String, dynamic>> snapshot
        in _firebaseProvider.getMessagesStreamByChatId(uuid)) {
      yield snapshot.docs
          .map(
            (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
                MessageMapper.mapFromFirebase(
              FirebaseMessage.fromJson(documentSnapshot.data()!),
            ),
          )
          .toList();
    }
  }

  @override
  Future<void> sendMessage(SendMessageRequest request) async {
    final List<String> files = request.files.isNotEmpty
        ? await _firebaseProvider.uploadFiles(request.files)
        : <String>[];

    final String senderUuid = _storageProvider.getString(
      StorageConstants.uuid,
    );

    final FirebaseMessage message = FirebaseMessage(
      files: files,
      chatUuid: request.chatUuid,
      senderUuid: senderUuid,
      text: request.text,
      sendTime: DateTime.now(),
    );

    await _firebaseProvider.sendMessage(message);
    await _firebaseProvider.setLastMessage(message);
  }

  @override
  Future<void> deleteChat(String uuid) async {
    await _firebaseProvider.deleteChat(uuid);
  }

  @override
  Stream<Chat> getChatStream(String uuid) async* {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> chatStream =
        await _firebaseProvider.getChatStream(uuid);

    await for (final DocumentSnapshot<Map<String, dynamic>> snapshot
        in chatStream) {
      yield ChatMapper.mapFromFirebase(
        FirebaseChat.fromJson(snapshot.data()!),
      );
    }
  }
}
