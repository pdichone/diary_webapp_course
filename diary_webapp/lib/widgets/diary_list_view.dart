import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:diary_webapp/util/utils.dart';
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
                    child: Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${formatDate(diary.entryTime!.toDate())}',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton.icon(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.grey,
                                    ),
                                    label: Text(''))
                              ],
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date...',
                                      style: TextStyle(color: Colors.green)),
                                  TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_horiz),
                                      label: Text('')),
                                ],
                              ),
                              SizedBox(
                                height: 150,
                                width: 200,
                                child: Container(
                                  color: Colors.green,
                                ),
                              ),
                              Text(diary.title!)
                            ],
                          ),
                        ),
                      ],
                    ),
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
