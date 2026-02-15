import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  void setDateAtPostCollection(String userEmail, String content) {
    final date = <String, dynamic>{
      "author": userEmail,
      "content": content,
      "likes": 0,
      "commentsLength": 0,
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

  Future<void> setContents(
    String userEmail,
    String oldContent,
    String newContent,
  ) async {
    final docs = await _db.collection("posts").get();

    for (var doc in docs.docs) {
      if (doc.data()["author"] == userEmail &&
          doc.data()["content"] == oldContent) {
        doc.reference.update({"content": newContent});
      }
    }
  }

  Future<void> deleteContent(String userEmail, String content) async {
    final docs = await _db.collection("posts").get();

    for (var doc in docs.docs) {
      if (doc.data()["author"] == userEmail &&
          doc.data()["content"] == content) {
        doc.reference.delete();
      }
    }
  }

  Future<List<Map<String, dynamic>>> getOwnPosts(String userEmail) async {
    List<Map<String, dynamic>> result = [];
    final docs = await _db.collection("posts").get();

    for (var doc in docs.docs) {
      if (doc.data()["author"] == userEmail) {
        result.add(doc.data());
      }
    }

    return result;
  }

  Future<String> getUserId(String userEmail) async {
    final ids = await _db.collection("users").doc("userIds").get();
    final data = ids.data();

    if (data == null) return userEmail;
    return data[userEmail] ?? userEmail;
  }

  Future<void> upsertUserId(String userEmail, String userId) async {
    if (userEmail == await getUserId(userEmail)) {
      await _db.collection("users").doc("userIds").set({userEmail: userId});
    } else {
      await _db.collection("users").doc("userIds").update({userEmail: userId});
    }
  }
}
