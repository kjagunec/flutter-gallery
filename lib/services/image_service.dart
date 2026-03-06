import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/image_model.dart';

class ImageService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _collectionName = 'images';

  Stream<List<ImageModel>> streamImages() {
    return _fireStore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ImageModel.fromDocument(doc)).toList();
    });
  }

  Future<void> addImage(ImageModel image) async {
    await _fireStore.collection(_collectionName).add(image.toMap());
  }

  Future<void> removeImage(String id) async {
    await _fireStore.collection(_collectionName).doc(id).delete();
  }
}
