import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpperSpace extends StatelessWidget {

  final double? alternativeHeight;

  const UpperSpace({super.key, this.alternativeHeight});

  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      if(alternativeHeight == null) {
        return Container();
      } else {
        return SizedBox(height: alternativeHeight);
      }
    }else {
      return SizedBox(height: 48.0);
    }
  }
}
