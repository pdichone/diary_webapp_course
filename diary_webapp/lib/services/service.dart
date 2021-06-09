import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:diary_webapp/model/user.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');

  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return;
  }

  Future<void> createUser(
      String displayName, BuildContext context, String uid) async {
    MUser user = MUser(
        avatarUrl: 'https://picsum.photos/200/300',
        displayName: displayName,
        uid: uid);
    userCollectionReference.add(user.toMap());
    return;
  }

  Future<void> update(MUser user, String displayName, String avatarUrl,
      BuildContext context) async {
    MUser updateUser =
        MUser(displayName: displayName, avatarUrl: avatarUrl, uid: user.uid);

    userCollectionReference.doc(user.id).update(updateUser.toMap());
    return;
  }

  // getAllDiariesByUser() {
  //   return diaryCollectionReference.snapshots().map((event) {
  //     return event.docs.map((diary) {
  //       return Diary.fromDocument(diary);
  //     }).where((element) {
  //       return (element.userId == FirebaseAuth.instance.currentUser!.uid);
  //     });
  //   });
  // }

  Future<List<Diary>> getSameDateDiaries(DateTime first, String userId) {
    return diaryCollectionReference
        .where('entry_time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
        .where('entry_time',
            isLessThan:
                Timestamp.fromDate(first.add(Duration(days: 1))).toDate())
        .where('user_id', isEqualTo: userId)
        .get()
        .then((value) {
      // print('Items ==> ${value.docs.length}');
      return value.docs.map((diary) {
        return Diary.fromDocument(diary);
      }).toList();
    });
  }
}
