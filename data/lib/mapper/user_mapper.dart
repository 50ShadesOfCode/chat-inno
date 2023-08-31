import 'package:data/entities/firebase_user.dart';
import 'package:domain/domain.dart';

class UserMapper {
  static User mapFromFirebase(FirebaseUser firebaseUser) {
    return User(
      username: firebaseUser.username,
      uuid: firebaseUser.uuid,
      imageUrl: firebaseUser.imageUrl,
    );
  }

  static FirebaseUser mapToFirebase(User user) {
    return FirebaseUser(
      imageUrl: user.imageUrl,
      uuid: user.uuid,
      username: user.username,
    );
  }
}
