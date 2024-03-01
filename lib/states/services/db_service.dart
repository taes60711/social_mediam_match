import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<dynamic> getChatInfo(String uid, String otherUid) {
    uid = "QWXvonFH0UDkrF0kXvIV";
    otherUid = "Q0PtLSHwhLk2EvZoA2aD";
    final stream = firestore.collection("friend_chatroom").doc(otherUid + "_" + uid).snapshots();

    return stream;
  }

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
}
