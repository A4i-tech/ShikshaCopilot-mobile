import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatelessWidget {
  final String url;

  const FullScreenImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white.withOpacity(0.95),
    body: Stack(
      children: <Widget>[
        PhotoView(
          imageProvider: CachedNetworkImageProvider(url),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2.0,
          heroAttributes: PhotoViewHeroAttributes(tag: url),
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          loadingBuilder: (BuildContext context, ImageChunkEvent? event) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) =>
                  const Center(
                    child: Icon(Icons.broken_image, color: Colors.black),
                  ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    ),
  );
}
