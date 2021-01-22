import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetail extends StatelessWidget {
  String imageUrl;
  String heroTag;
  PhotoDetail({this.imageUrl, this.heroTag});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Hero(
        tag: heroTag,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider){
            return PhotoView(
              imageProvider: imageProvider,
              minScale: 0.5,
              maxScale: 3.0,
            );
          },
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, err) => Icon(Icons.error),
        ),
      ),
    ));
  }
}