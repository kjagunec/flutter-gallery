import 'package:flutter/material.dart';
import 'package:gallery/models/image_model.dart';
import 'package:gallery/services/image_service.dart';

class AddView extends StatefulWidget {
  final ImageService imageService;
  final VoidCallback onAdded;

  const AddView({super.key, required this.imageService, required this.onAdded});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Image title'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _addImage, child: const Text('Add image')),
        ],
      ),
    );
  }

  void _addImage() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out both fields!')),
      );
    }

    final newImage = ImageModel(
      id: '',
      url: url,
      title: title,
      dateCreated: DateTime.now()
    );

    await widget.imageService.addImage(newImage);

    _titleController.clear();
    _urlController.clear();

    widget.onAdded();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image ${newImage.title} added successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}
