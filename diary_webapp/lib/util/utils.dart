import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatDateFromTimestamp(Timestamp? timestamp) {
  return DateFormat.yMMMd().add_EEEE().format(timestamp!.toDate());
}

String formatDateFromTimestampHour(Timestamp? timestamp) {
  return DateFormat.jm().format(timestamp!.toDate());
  //return DateFormat.yMMMd().add_jm().format(timestamp!.toDate());
}