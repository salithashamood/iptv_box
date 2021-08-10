import 'package:cloud_firestore/cloud_firestore.dart';

class Channel {
  final String name;
  final String img;
  final String url;

  Channel(this.name, this.img, this.url);

  Channel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        img = snapshot['img'],
        url = snapshot['url'];
}
