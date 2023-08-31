import 'dart:io';

import '../models/models.dart';

abstract class UserRepository {
  User? getLocalUser();

  Future<User> fetchLocalUser();

  Future<void> setUser(User user);

  Future<void> addUser(User user);

  Future<void> deleteUser();

  Future<void> setImage(File image);

  Future<User?> getUserByUuid(String uuid);

  Future<List<Chat>?> getChats();

  Future<void> generateRandomCredentials();
}
