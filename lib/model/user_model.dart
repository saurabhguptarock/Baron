import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final int followers;
  final int following;
  final int noOfNotification;
  final int soura;

  final String uid;
  final String email;
  final String photoUrl;
  final String name;
  final String tyre;
  final String badge;

  User({
    this.soura,
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
      soura: data['soura'] ?? 0,
    );
  }
}

class Collectible {
  final String img;
  final String name;
  final String quality;

  Collectible({this.img, this.name, this.quality});
  factory Collectible.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Collectible(
      img: data['img'] ?? '',
      name: data['name'] ?? '',
      quality: data['quality'] ?? '1',
    );
  }
}

class PhoneDetails {
  final String img;
  final String name;
  final String time;
  final bool wasIncoming;
  final bool wasmissed;

  PhoneDetails(
      {this.img, this.name, this.time, this.wasIncoming, this.wasmissed});
  factory PhoneDetails.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return PhoneDetails(
      img: data['img'] ?? '',
      name: data['name'] ?? '',
      time: data['time'] ?? '',
      wasIncoming: data['wasIncoming'] ?? false,
      wasmissed: data['wasmissed'] ?? false,
    );
  }
}

class Message {
  final User sender;
  final String time;
  final String text;
  final bool isUnread;

  Message({this.text, this.isUnread, this.sender, this.time});
}
