class User {
  final int followers;
  final int following;
  final int noOfNotification;

  final String uid;
  final String email;
  final String photoUrl;
  final String name;

  User({
    this.noOfNotification,
    this.followers,
    this.following,
    this.uid,
    this.email,
    this.photoUrl,
    this.name,
  });
  factory User.fromMap(Map data) {
    return User(
      noOfNotification: data['noOfNotification'] ?? 0,
      name: data['name'] ?? '',
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      followers: data['followers'] ?? 0,
      following: data['following'] ?? 0,
    );
  }
}
