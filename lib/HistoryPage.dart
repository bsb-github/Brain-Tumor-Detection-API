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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shadowColor: Colors.deepOrangeAccent,
                title: const Text(
                  "Delete History",
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  "Are you sure you want to delete history",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blueGrey[900],
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      )),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          isLoading = true;
                        });
                        var data = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("history");
                        data.get().then((value) {
                          for (var doc in value.docs) {
                            doc.reference.delete();
                          }
                        });
                        setState(() {
                          historyList.clear();
                          secondHistoryList.clear();
                          isLoading = false;
                        });
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      )),
                ],
              ),
            );
          },
          child: Center(
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        appBar: AppBar(
          title: const Text("History"),
        ),
        body: !isLoading
            ? SingleChildScrollView(
                child: Column(
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
                        //scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
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
                ),
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
