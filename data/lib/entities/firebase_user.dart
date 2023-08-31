class FirebaseUser {
  final String uuid;
  final String username;
  final String imageUrl;

  FirebaseUser({
    required this.imageUrl,
    required this.uuid,
    required this.username,
  });

  factory FirebaseUser.fromJson(Map<String, dynamic> data) {
    return FirebaseUser(
      imageUrl: data['image_url'],
      uuid: data['uuid'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'uuid': uuid,
      'image_url': imageUrl,
    };
  }
}
