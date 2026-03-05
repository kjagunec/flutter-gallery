import 'package:flutter/material.dart';
import 'package:gallery/screens/gallery_view/image_list.dart';

class GalleryView extends StatelessWidget{
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'Add'),
        ],
        currentIndex: 0,
      ),
    );
  }
}