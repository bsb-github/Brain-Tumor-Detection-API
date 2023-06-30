import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  static List<HistoryModal> historyList = [];
}

class HistoryModal {
  final String date;
  final String name;
  final String imageUrl;
  final String result;
  final String id;

  HistoryModal(
      {required this.date,
      required this.name,
      required this.imageUrl,
      required this.result,
      required this.id});

  static HistoryModal fromSnapshot(DocumentSnapshot snapshot) {
    return HistoryModal(
        date: snapshot['date'],
        name: snapshot['name'],
        imageUrl: snapshot['image'],
        result: snapshot['result'],
        id: snapshot['id']);
  }
}
