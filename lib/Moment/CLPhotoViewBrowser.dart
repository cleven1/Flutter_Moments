import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

/// 图片查看
class CLPhotoViewBrowser extends StatelessWidget {
  final Widget child;
  final List<String> pics;

  int currentIndex = 0;

  CLPhotoViewBrowser({Key key, this.child, @required this.pics, this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: ExtendedImageGesturePageView.builder(
              itemBuilder: (BuildContext context, int index) {
                var url = pics[index];
                Widget image = ExtendedImage.network(
                  url,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.Gesture,
                  gestureConfig: GestureConfig(
                      inPageView: true, initialScale: 1.0,
                      //you can cache gesture state even though page view page change.
                      //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                      cacheGesture: false
                  ),
                );
                image = Container(
                  child: image,
                  padding: EdgeInsets.all(5.0),
                );
                if (index == currentIndex) {
                  return Hero(
                    tag: url + index.toString(),
                    child: image,
                  );
                } else {
                  return image;
                }
              },
              itemCount: pics.length,
              onPageChanged: (int index) {
                currentIndex = index;
              },
              controller: PageController(
                initialPage: currentIndex,
              ),
              scrollDirection: Axis.horizontal,
            ),
    );
  }
}