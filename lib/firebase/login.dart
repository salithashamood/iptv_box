import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelData {
  Future getAllChannelData() async {
    final firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot =
          await firestore.collection('channel').orderBy('name').get();
      print(snapshot.docs.length);
      return snapshot.docs;
    } catch (e) {
      print(e.toString());
    }
  }

  Future getMovieChannelData() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection('channel')
        .where('category', isEqualTo: 'Movie')
        .get();
    return snapshot.docs;
  }

  Future getNewsChannelData() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection('channel')
        .where('category', isEqualTo: 'News')
        .get();
    return snapshot.docs;
  }

  Future getAnimationChannelData() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection('channel')
        .where('category', isEqualTo: 'Animation')
        .get();
    return snapshot.docs;
  }

  Future getMusicChannelData() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection('channel')
        .where('category', isEqualTo: 'Music')
        .get();
    return snapshot.docs;
  }
}
