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
                    child: Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${formatDateFromTimestamp(diary.entryTime)}',
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
                                  Text(
                                      '•${formatDateFromTimestampHour(diary.entryTime)}',
                                      style: TextStyle(color: Colors.green)),
                                  TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_horiz),
                                      label: Text('')),
                                ],
                              ),
                              Image.network((diary.photoUrls == null)
                                  ? 'https://picsum.photos/400/200'
                                  : diary.photoUrls.toString()),
                              Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(diary.title!,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              diary.entry!,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              )
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
