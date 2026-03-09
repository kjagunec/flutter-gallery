import 'package:flutter/material.dart';
import 'package:gallery/models/image_model.dart';
import 'package:gallery/screens/detail_view/detail_view.dart';
import 'package:gallery/services/image_service.dart';

class ImageView extends StatelessWidget {
  final ImageService imageService;

  const ImageView({super.key, required this.imageService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: imageService.streamImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildError(snapshot.error);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoData();
        }

        final images = snapshot.data!;
        return _buildImageList(images);
      },
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(Object? error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildNoData() {
    return const Center(child: Text('No images available'));
  }

  Widget _buildImageList(List<ImageModel> images) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return _buildImageItem(context, image);
      },
    );
  }

  Widget _buildImageItem(BuildContext context, ImageModel image) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailView(image: image)),
            ),
            child: Hero(
              tag: image.id,
              child: Image.network(image.url, fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.black87,
              tooltip: 'Delete Image',
              onPressed: () => _confirmAndDelete(context, image),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmAndDelete(BuildContext context, ImageModel image) async {
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
      await imageService.removeImage(image.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Deleted: ${image.title}')));
      }
    }
  }
}
