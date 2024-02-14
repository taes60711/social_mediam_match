import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<dynamic> getChatRoomListData(String uid) {
    uid = "QWXvonFH0UDkrF0kXvIV";
    final streams = firestore.collection("user_chatlist").doc(uid).snapshots();
    return streams;
  }

  Stream<List<dynamic>> getCourseData() {
    final stream = firestore.collection("courses").snapshots();
    inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
    return stream.map((e) => e.docs.map((e) => e.data()).toList());
  }

  Stream<List<dynamic>> getPostData() {
    final stream = firestore.collection("posts").snapshots();
    inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
    return stream.map((e) => e.docs.map((e) => e.data()).toList());
  }

  Stream<List<dynamic>> getData() {
    final stream = firestore.collection("users").snapshots();
    inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
    return stream.map((e) => e.docs.map((e) => e.data()).toList());
  }

  Future<Map<String, dynamic>> getDataAtOnce(String uid) async {
    uid = "QWXvonFH0UDkrF0kXvIV";
    DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
    Map<String, dynamic> resultData = doc.data() as Map<String, dynamic>;
    log("${resultData}");
    return resultData;
  }

  Future<void> addData(String email) async {
    Map<String, String> data = {"email": email};
  }

  Future<void> signUp(String email) async {
    //CreateData Sample
    Map<String, dynamic> data = {"email": email, 'isEmailVerified': false};
    await firestore
        .collection("users")
        .add(data)
        .then((result) => firestore
            .collection("users")
            .doc(result.id)
            .update({"docId": result.id}))
        .then((value) {
      log('data insert into database');
    });
  }
}
