import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchImages() async {
    final snapshot = await _firestore.collection('images').get();
    return snapshot.docs
        .map(
          (doc) => {
        'url': doc['url'],
        'title': doc['title'],
        'dateCreated': doc['dateCreated'],
      },
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No images available.');
        }

        final images = snapshot.data!;
        return ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            final image = images[index];
            return ListTile(
              contentPadding: EdgeInsets.all(8),
              title: Text(image['title']),
              subtitle: Text('subtitle'),
              leading: Image.network(image['url']),
            );
          },
        );
      },
    );
  }
}