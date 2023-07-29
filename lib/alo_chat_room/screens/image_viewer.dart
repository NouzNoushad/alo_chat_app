import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../../core/colors.dart';

class ImageViewer extends StatelessWidget {
  final ImageProvider? imageProvider;
  final LoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? title;
  const ImageViewer({
    super.key,
    required this.title,
    this.imageProvider,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 10,
        backgroundColor: CustomColors.backgroundColor1,
        automaticallyImplyLeading: true,
        title: Text(
          title ?? '',
          maxLines: 3,
          style: const TextStyle(
              color: CustomColors.backgroundColor2,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0.0,
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
        ),
      ),
    );
  }
}
