import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_webapp/model/Diary.dart';
import 'package:diary_webapp/screens/main_page.dart';
import 'package:flutter/material.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.bookCollectionReference,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Object?> bookCollectionReference;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Entry?',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
          'Are you sure you want to delete the entry? \n This action cannot be reversed'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            //we delete the entry!
            bookCollectionReference.doc(diary.id).delete().then((value) {
              //return Navigator.of(context).pop();
              return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ));
            });
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
