import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/HistoryInfo.dart';
import 'package:fyp/Modal/HistoryName.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryModal> historyList = [];
  bool isLoading = true;
  void getHistory() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("history")
        .get();
    for (var doc in data.docs) {
      setState(() {
        historyList.add(HistoryModal.fromSnapshot(doc));
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getHistory();
    super.initState();
  }

  search(String name) {
    List<HistoryModal> searchList = [];
    searchList.addAll(historyList);
    if (name.isNotEmpty) {
      List<HistoryModal> dummyListData = [];
      searchList.forEach((item) {
        if (item.name.contains(name)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        historyList.clear();
        historyList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        historyList.clear();
        historyList.addAll(searchList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("History"),
        ),
        body: !isLoading
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        search(value);
                      },
                      decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryInfo(
                                    historyModal: historyList[index],
                                  ),
                                ));
                          },
                          child: Card(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              title: Text(historyList[index].name),
                              subtitle: Text(historyList[index].result),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
      ),
    );
  }
}
