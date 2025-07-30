import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/asset_location.dart';

class WelcomeBackgroundWidget extends StatelessWidget {
  final Widget child;

  const WelcomeBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetLocation.welcomeBackgroundPngLocation),
            fit: BoxFit.cover,
            opacity: 0.5
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.black,
            ),
          ],
        ),
        child: WelcomeFormCardWidget(child: child),
      ),
    );
  }
}

class WelcomeFormCardWidget extends StatelessWidget {
  final Widget child;

  const WelcomeFormCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: AppColor.lightGrey,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}