import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class CachedImage extends StatelessWidget {
  String? imageUrl;
  double topLeftradious;
  double topRightradious;
  double bottomLeftradious;
  double bottomRightradious;
  double height;
  double width;
  CachedImage({
    super.key,
    this.imageUrl,
    this.height = 190,
    this.width = 300,
    this.topLeftradious = 0,
    this.topRightradious = 0,
    this.bottomLeftradious = 0,
    this.bottomRightradious = 0,
  });

  @override
  Widget build(BuildContext context) {
    // return ClipRRect(
    //   borderRadius: BorderRadius.all(Radius.circular(radious)),
    //   child: CachedNetworkImage(
    //     fit: BoxFit.fill,
    //     imageUrl: imageUrl ?? '',
    //     errorWidget: (context, url, error) {
    //       return  SizedBox(
    //         child: Image.asset("assets/images/placeholder.png"),
    //       );
    //     },
    //     placeholder: (context, url) {
    //       return SizedBox(
    //         child: Image.asset("assets/images/placeholder.png"),
    //       );
    //     },
    //   ),
    // );
    return ImageNetwork(
      image: imageUrl!,
      height: height,
      width: width,
      duration: 1500,
      curve: Curves.easeIn,
      onPointer: true,
      fitAndroidIos: BoxFit.fill,
      fitWeb: BoxFitWeb.fill,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftradious),
          topRight: Radius.circular(topRightradious),
          bottomLeft: Radius.circular(bottomLeftradious),
          bottomRight: Radius.circular(bottomRightradious)),
      onLoading: const CircularProgressIndicator(
        color: Colors.blueAccent,
      ),
      onError: const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}
