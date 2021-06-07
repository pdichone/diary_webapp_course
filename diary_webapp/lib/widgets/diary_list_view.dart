import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        var filteredList = snapshot.data!.docs.map((diary) {
          return Diary.fromDocument(diary);
        }).where((item) {
          return (item.userId == FirebaseAuth.instance.currentUser!.uid);
        }).toList();

        return Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            Diary diary = filteredList[index];
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Card(
                                elevation: 4.0,
                                child: ListTile(
                                  title: Text(diary.title!),
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  ))
                ],
              ),
            ));
      },
    );
  }
}
