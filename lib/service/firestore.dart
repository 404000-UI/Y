import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  void setDateAtPostCollection(String userEmail, String content) {
    final date = <String, dynamic>{
      "user": userEmail,
      "content": content,
      "likes": 0,
    };

    _db.collection("posts").doc(DateTime.now().toString()).set(date);
  }

  Future<List<Map<String, dynamic>>> getAllPosts() async {
    final docs = await _db.collection("posts").get();
    List<Map<String, dynamic>> datas = [];

    for (var doc in docs.docs) {
      Map<String, dynamic> data = doc.data();
      datas.add(data);
    }
    return datas;
  }
}
