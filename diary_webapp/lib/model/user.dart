import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String? uid;
  final String? displayName;
  final String? profession;
  final String? avatarUrl;

  MUser({this.id, this.uid, this.displayName, this.profession, this.avatarUrl});

  factory MUser.fromDocument(DocumentSnapshot data) {
    return MUser(
        id: data.id,
  
        uid: data.get('uid'),
        displayName: data.get('display_name'),
        profession: data.get('profession'),
        avatarUrl: data.get('avatar_url'));
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'display_name': displayName,
      'profession': profession,
      'avatar_url': avatarUrl
    };
  }
}
