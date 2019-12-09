import 'dart:async';

import 'package:Baron/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
]);
final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

Future<void> login() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  AuthResult result = await _auth.signInWithCredential(credential);
  createUserDatabase(result.user);
}

Future<void> createUserDatabase(FirebaseUser user) async {
  var doc = await _firestore.document('users/${user.uid}').get();
  if (!doc.exists) {
    var userRef = _firestore.document('users/${user.uid}');
    var data = {
      'uid': user.uid,
      'photoUrl': user.photoUrl,
      'name': user.displayName,
      'email': user.email,
      'noOfNotification': 0,
      'tyre': 'Bronze',
      'badge': 'Elite',
      'followers': 0,
      'following': 0,
      'soura': 0,
    };
    userRef.setData(data, merge: true);
  }
}

Stream<User> streamUser(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .snapshots()
      .map((snap) => User.fromMap(snap.data));
}

Stream<List<PhoneDetails>> streamPhoneDetails(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .collection('phoneDetails')
      // .where('calledByUid', isEqualTo: uid)
      .orderBy('time', descending: true)
      .snapshots()
      .map((list) => list.documents
          .map((data) => PhoneDetails.fromFirestore(data))
          .toList());
}

Stream<List<Collectible>> streamCollectible() {
  return _firestore
      .collection('collectibles')
      // .orderBy('quality', descending: true)
      .snapshots()
      .map((list) => list.documents
          .map((data) => Collectible.fromFirestore(data))
          .toList());
}

void buyCollectible(Collectible collectible, User userDetails, int cost) {
  _firestore
      .collection('users')
      .document(userDetails.uid)
      .updateData({'soura': FieldValue.increment(-cost)}).then((v) {
    _firestore
        .collection('users')
        .document(userDetails.uid)
        .collection('inventory')
        .add({
      'name': collectible.name,
      'quality': collectible.quality,
      'docId': '',
      'img': collectible.img,
    }).then((data) => data.updateData({'docId': data.documentID}));
  });
}

void signOut() {
  _auth.signOut();
}

// void sendNotification(String currentUser){}

void deleteTile(String uid, String docId) {
  _firestore
      .collection('users')
      .document(uid)
      .collection('phoneDetails')
      .where('docId', isEqualTo: docId)
      .getDocuments()
      .then((v) {
    v.documents.forEach((f) {
      f.reference.delete();
    });
  });
}

void updateCoins(String uid, int noOfCoins) {
  _firestore
      .collection('users')
      .document(uid)
      .updateData({'soura': FieldValue.increment(noOfCoins)});
}

void callUserBackend(User currentUser, String channelName,
    [Map<String, dynamic> userToCall]) {
  _firestore
      .collection('users')
      .document(currentUser.uid)
      .collection('phoneDetails')
      .add({
    'img': userToCall['photoUrl'],
    'name': userToCall['name'],
    'time': '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}',
    'docId': '',
    'wasIncoming': false,
    'channelName': channelName,
    'calledByUid': currentUser.uid,
    'calledToUid': userToCall['uid']
  }).then((data) => data.updateData({'docId': data.documentID}));

  _firestore
      .collection('users')
      .document(userToCall['uid'])
      .collection('phoneDetails')
      .add({
    'img': currentUser.photoUrl,
    'name': currentUser.name,
    'time': '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}',
    'docId': '',
    'wasIncoming': true,
    'channelName': channelName,
    'calledByUid': currentUser.uid,
    'calledToUid': userToCall['uid']
  }).then((data) => data.updateData({'docId': data.documentID}));
}
