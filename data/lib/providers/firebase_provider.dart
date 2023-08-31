import 'dart:io';

import 'package:core/core.dart';
import 'package:data/entities/firebase_chat.dart';
import 'package:data/entities/firebase_message.dart';
import 'package:data/entities/firebase_user.dart';
import 'package:path/path.dart';

class FirebaseProvider {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseProvider({
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage,
        _firebaseFirestore = firebaseFirestore;

  Future<FirebaseUser?> getFirebaseUserById(String id) async {
    final DocumentReference<Map<String, dynamic>> docRef =
        _firebaseFirestore.collection('users').doc(id);

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

    final Map<String, dynamic>? data = snapshot.data();

    return data != null ? FirebaseUser.fromJson(data) : null;
  }

  Future<FirebaseUser?> getFirebaseUserByUuid(String uuid) async {
    final Query<Map<String, dynamic>> query =
        _firebaseFirestore.collection('users').where(
              'uuid',
              isEqualTo: uuid,
            );
    final QuerySnapshot<Map<String, dynamic>> data = await query.get();

    return data.docs.isEmpty
        ? null
        : FirebaseUser.fromJson(data.docs.first.data());
  }

  Future<String> addFirebaseUser(FirebaseUser firebaseUser) async {
    String id = '';
    await _firebaseFirestore
        .collection('users')
        .add(firebaseUser.toJson())
        .then(
          (DocumentReference<Map<String, dynamic>> documentSnapshot) =>
              id = documentSnapshot.id,
        );
    return id;
  }

  Future<void> setFirebaseUser(String id, FirebaseUser firebaseUser) async {
    await _firebaseFirestore
        .collection('users')
        .doc(id)
        .set(firebaseUser.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _firebaseFirestore.collection('users').doc(id).delete();
  }

  Future<String> setImage(String uuid, File image) async {
    final Reference storageRef = _firebaseStorage.ref();

    final Reference imageRef =
        storageRef.child('images/$uuid/${basename(image.path)}');

    await imageRef.putFile(image);

    return await imageRef.getDownloadURL();
  }

  //TODO: rework to single request
  Future<List<FirebaseChat>> getChats(String uuid) async {
    final QuerySnapshot<Map<String, dynamic>> snapshotSender =
        await _firebaseFirestore
            .collection('chats')
            .where('sender_uuid', isEqualTo: uuid)
            .get();
    final QuerySnapshot<Map<String, dynamic>> snapshotReceiver =
        await _firebaseFirestore
            .collection('chats')
            .where('receiver_uuid', isEqualTo: uuid)
            .get();

    final List<FirebaseChat> listSender = snapshotSender.docs.isEmpty
        ? <FirebaseChat>[]
        : snapshotSender.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
            AppLogger().warning(snapshot.data());
            return FirebaseChat.fromJson(snapshot.data());
          }).toList();

    final List<FirebaseChat> listReceiver = snapshotReceiver.docs.isEmpty
        ? <FirebaseChat>[]
        : snapshotReceiver.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
                FirebaseChat.fromJson(snapshot.data()))
            .toList();

    return <FirebaseChat>[...listSender, ...listReceiver];
  }

  Future<void> createChat(FirebaseChat chat) async {
    await _firebaseFirestore.collection('chats').add(chat.toJson());
  }

  Future<void> deleteChat(String uuid) async {
    await _firebaseFirestore.collection('chats').doc(uuid).delete();
  }

  Future<List<String>> uploadFiles(List<File> files) async {
    final Reference storageRef = _firebaseStorage.ref();

    final List<String> urls = <String>[];

    for (final File file in files) {
      final Reference fileRef =
          storageRef.child('files/${basename(file.path)}');
      await fileRef.putFile(file);
      final String downloadUrl = await fileRef.getDownloadURL();
      urls.add(downloadUrl);
    }

    return urls;
  }

  Future<void> sendMessage(FirebaseMessage message) async {
    await _firebaseFirestore.collection(message.chatUuid).add(message.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesStreamByChatId(
      String uuid) {
    AppLogger().debug('uuid: $uuid');
    return _firebaseFirestore.collection(uuid).orderBy('send_time').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatsStreamByChatId(
      String uuid) {
    //TODO: check later
    return _firebaseFirestore
        .collection('chats')
        .where('sender_uuid', isEqualTo: uuid)
        .snapshots();
  }

  Future<void> setLastMessage(FirebaseMessage message) async {
    final QuerySnapshot<Map<String, dynamic>> docs = await _firebaseFirestore
        .collection('chats')
        .where('uuid', isEqualTo: message.chatUuid)
        .get();

    docs.docs.first.reference.update(<String, dynamic>{
      'last_message': message.toJson(),
    });
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getChatStream(
      String uuid) async {
    final QuerySnapshot<Map<String, dynamic>> docs = await _firebaseFirestore
        .collection('chats')
        .where('uuid', isEqualTo: uuid)
        .get();

    return docs.docs.first.reference.snapshots();
  }
}
