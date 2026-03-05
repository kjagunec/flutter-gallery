import 'package:flutter/material.dart';
import 'package:gallery/screens/gallery_view/image_list.dart';

class GalleryView extends StatelessWidget{
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageList(),
    );
  }
}