import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  ImageListState createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
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
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No images available.'));
        }

        final images = snapshot.data!;
        return ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            final image = images[index];
            return Stack(
              children: [
                Image.network(
                  image['url'],
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: 8,   // distance from top
                  right: 8, // distance from right
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white54, // semi-transparent background
                      //shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      //color: Colors.white,
                      //size: 20,
                    ),
                  ),
                ),
              ],
            );
            /*return ListTile(
              contentPadding: EdgeInsets.all(8),
              title: Text(image['title']),
              subtitle: Text('subtitle'),
              leading: Image.network(image['url']),
            );*/
          },
        );
      },
    );
  }
}
