import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class ImageDetails extends StatelessWidget {
  final String image;

  const ImageDetails(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            IconButton(
              alignment: Alignment.bottomCenter,
              icon: Icon(
                Icons.close,
                color: ColorsUtil.appColor,
                size: 50,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Center(
              child: Hero(
                tag: 'imageHero',
                child: Image.network(
                  image,
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.scaleDown,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
