import 'package:flutter/material.dart';
import 'package:mylaundry/widgets/image_error_placeholder.dart';

class NetworkImagePlaceholder extends StatelessWidget {
  final String imgUrl;
  const NetworkImagePlaceholder({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage('assets/images/placeholder_laundry.jpg'),
      image: NetworkImage(Uri.encodeFull(imgUrl)),
      fit: BoxFit.cover,
      imageErrorBuilder:
          (context, error, stackTrace) => ImageErrorPlaceholder(),
    );
  }
}
