import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class LeftTitleText extends StatelessWidget {
  final String text;

  const LeftTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class LeftSubTitleText extends StatelessWidget {
  final String text;

  const LeftSubTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String text;

  const SubTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class CenteredBoldText extends StatelessWidget {
  final String text;

  const CenteredBoldText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class LeftBoldText extends StatelessWidget {
  final String text;

  const LeftBoldText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RightBoldText extends StatelessWidget {
  final String text;

  const RightBoldText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.right,
    );
  }
}

class CenteredText extends StatelessWidget {
  final String text;

  const CenteredText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class LeftText extends StatelessWidget {
  final String text;

  const LeftText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
      ),
    );
  }
}

class RightText extends StatelessWidget {
  final String text;

  const RightText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
      ),
      textAlign: TextAlign.right,
    );
  }
}

class GreenCategoryText extends StatelessWidget {
  final String text;

  const GreenCategoryText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColor.green,
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class GreenSlashText extends StatelessWidget {
  const GreenSlashText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '/',
      style: TextStyle(
        color: AppColor.green,
        fontFamily: 'Montserrat',
        fontSize: 24.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class DialogButtonText extends StatelessWidget {
  final String text;
  final Color color;

  const DialogButtonText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
