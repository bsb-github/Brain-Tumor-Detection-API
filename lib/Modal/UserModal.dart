import 'package:cloud_firestore/cloud_firestore.dart';

class UserList {
  static List<UserModal> userList = [];
}

class UserModal {
  final String name;
  final String email;
  final String doB;
  final String cnicNo;
  final String docType;
  final String imgUrl;

  UserModal(
      {required this.name,
      required this.email,
      required this.doB,
      required this.docType,
      required this.cnicNo,
      required this.imgUrl});

  static UserModal fromSnapshot(DocumentSnapshot json) {
    return UserModal(
        docType: json["docType"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        doB: json["doB"] ?? "",
        cnicNo: json["cnicNo"] ?? "",
        imgUrl: json["imgUrl"] ?? "");
  }
}
