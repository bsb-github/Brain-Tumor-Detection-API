import 'package:flutter/material.dart';
import 'package:fyp/Modal/HistoryName.dart';

class HistoryInfo extends StatelessWidget {
  final HistoryModal historyModal;

  const HistoryInfo({super.key, required this.historyModal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(historyModal.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Image.network(historyModal.imageUrl),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Result: " + historyModal.result,
              style: TextStyle(fontSize: 20, color: Colors.deepOrangeAccent),
            ),
          ],
        ),
      ),
    );
  }
}
