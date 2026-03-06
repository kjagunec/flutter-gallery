import 'package:flutter/material.dart';
import 'package:gallery/screens/gallery_view/gallery_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GalleryView()
    );
  }
}
