import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:diary_webapp/screens/main_page.dart';
import 'package:diary_webapp/util/utils.dart';
import 'package:diary_webapp/widgets/delete_entry_dialog.dart';
import 'package:diary_webapp/widgets/inner_list_card.dart';
import 'package:diary_webapp/widgets/write_diary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required List<Diary> listOfDiaries,
    required this.selectedDate,
  })  : _listOfDiaries = listOfDiaries,
        super(key: key);
  final DateTime selectedDate;
  final List<Diary> _listOfDiaries;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    final _user = Provider.of<User?>(context);

    var _diaryList = this._listOfDiaries;
    var filteredDiaryList = _diaryList.where((element) {
      return (element.userId == _user!.uid);
    }).toList();
    return Column(
      children: [
        Expanded(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: (filteredDiaryList.isNotEmpty)
              ? ListView.builder(
                  itemCount: filteredDiaryList.length,
                  itemBuilder: (context, index) {
                    Diary diary = filteredDiaryList[index];
                    
                    return Card(
                      elevation: 4.0,
                      child: InnerListCard(
                          selectedDate: this.selectedDate,
                          diary: diary,
                          bookCollectionReference: bookCollectionReference),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4.0,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Safeguard your memory on ${formatDate(selectedDate)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  TextButton.icon(
                                    icon: Icon(Icons.lock_outline_sharp),
                                    label: Text('Click to Add an Entry'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WriteDiaryDialog(
                                              selectedDate: selectedDate,
                                              titleTextController:
                                                  _titleTextController,
                                              descriptionTextController:
                                                  _descriptionTextController);
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ))
      ],
    );
  }
}

/*
StreamBuilder<QuerySnapshot>(
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
                      scrollDirection: Axis.vertical,
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
          )
*/
