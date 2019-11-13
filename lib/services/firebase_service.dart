import 'package:Baron/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

Stream<List<RecentActivity>> streamRecentActivity(String uid) {
  return _firestore
      .collection('users')
      .document(uid)
      .collection('recentActivity')
      .snapshots()
      .map((list) => list.documents
          .map((data) => RecentActivity.fromFirestore(data))
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

void signOut() {
  _auth.signOut();
}

void updateFollowers(String uid) {
  _firestore
      .collection('users')
      .document(uid)
      .updateData({'followers': FieldValue.increment(1)});
}

void updateFollowing(String uid) {
  _firestore
      .collection('users')
      .document(uid)
      .updateData({'following': FieldValue.increment(1)});
}
