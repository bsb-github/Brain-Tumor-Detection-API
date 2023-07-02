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
  List<HistoryModal> secondHistoryList = [];
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
      secondHistoryList.addAll(historyList);
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("History"),
        ),
        body: !isLoading
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 0) {
                          setState(() {
                            historyList.clear();
                            historyList.addAll(secondHistoryList);
                          });
                        } else {
                          setState(() {
                            historyList.clear();
                            historyList.addAll(secondHistoryList);
                          });
                          search(value);
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
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
                              leading: const Icon(
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
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
      ),
    );
  }
}
