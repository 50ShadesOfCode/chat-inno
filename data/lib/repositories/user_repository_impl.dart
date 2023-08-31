import 'dart:io';

import 'package:core/core.dart';
import 'package:data/entities/entities.dart';
import 'package:data/entities/firebase_chat.dart';
import 'package:data/mapper/chat_mapper.dart';
import 'package:data/mapper/user_mapper.dart';
import 'package:data/providers/firebase_provider.dart';
import 'package:data/providers/storage_provider.dart';
import 'package:domain/domain.dart';

class UserRepositoryImpl extends UserRepository {
  final StorageProvider _storageProvider;
  final FirebaseProvider _firebaseProvider;

  UserRepositoryImpl({
    required StorageProvider storageProvider,
    required FirebaseProvider firebaseProvider,
  })  : _storageProvider = storageProvider,
        _firebaseProvider = firebaseProvider;

  @override
  Future<void> generateRandomCredentials() async {}

  @override
  Future<User> fetchLocalUser() async {
    final String id = _storageProvider.getString(
      StorageConstants.id,
    );
    final FirebaseUser? firebaseUser =
        await _firebaseProvider.getFirebaseUserById(id);

    return firebaseUser != null
        ? UserMapper.mapFromFirebase(
            firebaseUser,
          )
        : User(username: '', uuid: '', imageUrl: '');
  }

  @override
  User? getLocalUser() {
    final String username = _storageProvider.getString(
      StorageConstants.username,
    );
    final String uuid = _storageProvider.getString(
      StorageConstants.uuid,
    );
    final String imageUrl = _storageProvider.getString(
      StorageConstants.imageUrl,
    );
    if (uuid == '') {
      return null;
    } else {
      return User(
        username: username,
        uuid: uuid,
        imageUrl: imageUrl,
      );
    }
  }

  @override
  Future<void> setUser(User user) async {
    final String id = _storageProvider.getString(
      StorageConstants.id,
    );

    AppLogger().debug(user.imageUrl);

    String imageUrl = '';

    if (user.imageUrl != '') {
      imageUrl = await setImage(File(user.imageUrl));
    }

    await _firebaseProvider.setFirebaseUser(
      id,
      UserMapper.mapToFirebase(
        User(
          uuid: user.uuid,
          username: user.username,
          imageUrl: imageUrl,
        ),
      ),
    );

    await _storageProvider.setString(
      StorageConstants.username,
      user.username,
    );
    await _storageProvider.setString(
      StorageConstants.uuid,
      user.uuid,
    );
  }

  @override
  Future<void> addUser(User user) async {
    String imageUrl = '';
    if (user.imageUrl != '') {
      imageUrl = await setImage(File(user.imageUrl));
    }

    final String id = await _firebaseProvider.addFirebaseUser(
      UserMapper.mapToFirebase(
        User(
          username: user.username,
          uuid: user.uuid,
          imageUrl: imageUrl,
        ),
      ),
    );
    await _storageProvider.setString(
      StorageConstants.id,
      id,
    );
    await _storageProvider.setString(
      StorageConstants.username,
      user.username,
    );
    await _storageProvider.setString(
      StorageConstants.uuid,
      user.uuid,
    );
  }

  @override
  Future<void> deleteUser() async {
    final String id = _storageProvider.getString(
      StorageConstants.id,
    );
    if (id == '') {
      return;
    }
    await _firebaseProvider.deleteUser(id);
    _storageProvider.setString(
      StorageConstants.imageUrl,
      '',
    );
    _storageProvider.setString(
      StorageConstants.username,
      '',
    );
    _storageProvider.setString(
      StorageConstants.uuid,
      '',
    );
    _storageProvider.setString(
      StorageConstants.id,
      '',
    );
  }

  @override
  Future<String> setImage(File image) async {
    final String uuid = _storageProvider.getString(
      StorageConstants.uuid,
    );
    final String imageUrl = await _firebaseProvider.setImage(uuid, image);
    await _storageProvider.setString(
      StorageConstants.imageUrl,
      imageUrl,
    );
    return imageUrl;
  }

  @override
  Future<User?> getUserByUuid(String uuid) async {
    final FirebaseUser? firebaseUser =
        await _firebaseProvider.getFirebaseUserByUuid(uuid);
    return firebaseUser == null
        ? null
        : UserMapper.mapFromFirebase(firebaseUser);
  }

  @override
  Future<List<Chat>?> getChats() async {
    final String uuid = _storageProvider.getString(
      StorageConstants.uuid,
    );
    final List<FirebaseChat> firebaseChats =
        await _firebaseProvider.getChats(uuid);
    final List<Chat> chats = firebaseChats
        .map((FirebaseChat chat) => ChatMapper.mapFromFirebase(chat))
        .toList();
    return chats.isEmpty ? null : chats;
  }
}
