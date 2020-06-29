import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreHelper {
  static String getReadableTime(Timestamp timestamp) {
    final format = DateFormat.yMMMMd();
    var date = new DateTime.fromMillisecondsSinceEpoch(
      timestamp.millisecondsSinceEpoch,
    );
    return format.format(date);
  }
}