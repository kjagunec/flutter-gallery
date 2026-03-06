import 'package:flutter/material.dart';
import 'package:gallery/services/image_service.dart';

class ImageList extends StatelessWidget {
  final ImageService _imageService = ImageService();

  ImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _imageService.streamImages(),
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
                Center(child: Image.network(image.url)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete "${image.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirmDelete == true) {
                        await _imageService.removeImage(image.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Deleted: ${image.title}')),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white54),
                      child: const Icon(Icons.delete),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
