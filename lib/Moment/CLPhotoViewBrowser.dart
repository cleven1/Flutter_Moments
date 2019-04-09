import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';

/// 图片查看
class CLPhotoViewBrowser extends StatelessWidget {
  final Widget child;
  final int initialPage;
  final List<PhotoViewGalleryPageOptions> galleryList;
  final Widget loadingChild;

  CLPhotoViewBrowser({Key key, this.child, this.initialPage, this.galleryList, this.loadingChild}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: PhotoViewGallery(
              // loadingChild: loadingChild,
              pageController: PageController(
                initialPage: initialPage,
              ),
              pageOptions: galleryList,
              backgroundDecoration: BoxDecoration(color: Colors.black87),
              gaplessPlayback: true,
              transitionOnUserGestures: true, 
              ),
      ),
    );
  }
}