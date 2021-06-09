import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:diary_webapp/screens/main_page.dart';
import 'package:diary_webapp/util/utils.dart';
import 'package:diary_webapp/widgets/delete_entry_dialog.dart';
import 'package:diary_webapp/widgets/inner_list_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    return StreamBuilder<QuerySnapshot>(
      stream: bookCollectionReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        var filteredList = snapshot.data!.docs.map((diary) {
          return Diary.fromDocument(diary);
        }).where((item) {
          return (item.userId == FirebaseAuth.instance.currentUser!.uid);
        }).toList();

        return Column(
          children: [
            Expanded(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  Diary diary = filteredList[index];
                  return Card(
                    elevation: 4.0,
                    child: InnerListCard(
                        selectedDate: this.selectedDate,
                        diary: diary,
                        bookCollectionReference: bookCollectionReference),
                  );
                },
              ),
            ))
          ],
        );
      },
    );
  }
}
