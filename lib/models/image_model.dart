import 'package:cloud_firestore/cloud_firestore.dart';

class ImageModel {
  final String id;
  final String url;
  final String title;
  final DateTime? dateCreated;

  ImageModel({
    required this.id,
    required this.url,
    required this.title,
    required this.dateCreated,
  });

  factory ImageModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) throw Exception("Document ${doc.id} has no data!");

    return ImageModel(
      id: doc.id,
      url: data['url'],
      title: data['title'],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'url': url, 'title': title, 'dateCreated': dateCreated};
  }
}
