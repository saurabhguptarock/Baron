class User {
  final int followers;
  final int following;
  final int noOfNotification;

  final String uid;
  final String email;
  final String photoUrl;
  final String name;
  final String tyre;
  final String badge;

  User({
    this.tyre,
    this.badge,
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
      tyre: data['tyre'] ?? 'Bronze',
      badge: data['badge'] ?? 'Elite',
      name: data['name'] ?? '',
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      followers: data['followers'] ?? 0,
      following: data['following'] ?? 0,
    );
  }
}
