import 'package:flutter/material.dart';

class TopImageCard extends StatelessWidget{

  final String imageLink;

  const TopImageCard({super.key, required this.imageLink});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: Image(
          height: 106,
          image: NetworkImage(
            imageLink,
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          ),
          fit: BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object exception,
              StackTrace? stackTrace) {
            return const Center(child: Text('Image not available'));
          },
        ),
      ),
    );
  }

}