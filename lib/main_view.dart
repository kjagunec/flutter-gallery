import 'package:flutter/material.dart';
import 'package:gallery/screens/add_view/add_view.dart';
import 'package:gallery/screens/image_view/image_view.dart';
import 'package:gallery/services/image_service.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final ImageService _imageService = ImageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentIndex == 0 ? 'Gallery' : 'Add Image')),
      body: _currentIndex == 0
          ? ImageView(imageService: _imageService)
          : AddView(
              imageService: _imageService,
              onAdded: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'Add'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
