import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_color.dart';
import '../utils/asset_location.dart';
import 'dialog_button.dart';
import 'text.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmButtonText,
    required this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: SizedBox(
              child:
              SvgPicture.asset(AssetLocation.confirmationDialogIconSvgLocation),
            ),
          ),
          const SizedBox(height: 32),
          SubTitleText(
            text: message,
          ),
          const SizedBox(height: 32),
          DialogButton(
            text: confirmButtonText,
            onPressed: () {
              onConfirm?.call();
            },
            backGroundColor: AppColor.green,
            textColor: AppColor.white,
          ),
          const SizedBox(height: 32),
          DialogButton(
            text: cancelButtonText,
            onPressed: () {
              onCancel?.call();
            },
            backGroundColor: AppColor.white,
            textColor: AppColor.black,
          ),
        ],
      ),
    );
  }
}
