import 'package:flutter/material.dart';
import 'package:offro_cibo/ui/components/text.dart';
import 'package:provider/provider.dart';

import '../../../components/cta_button.dart';
import '../../../components/get_message_snackbar.dart';
import '../../../utils/app_string.dart';
import '../components/email_input_field.dart';
import '../components/welcome_screen.dart';
import 'rescue_password_viewmodel.dart';

class RescuePasswordScreenWidget extends StatefulWidget {
  const RescuePasswordScreenWidget({super.key});

  @override
  State<RescuePasswordScreenWidget> createState() =>
      _RescuePasswordScreenWidgetState();
}

class _RescuePasswordScreenWidgetState
    extends State<RescuePasswordScreenWidget> {
  late final RescuePasswordViewModel _rescuePasswordViewModel =
      Provider.of<RescuePasswordViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return WelcomeBackgroundWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubTitleText(text: AppString.rescue_password_screen__card_title),
          const SizedBox(height: 16.0),
          Text(
            AppString.rescue_password_screen__card_subtitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32.0),
          EmailInputField(
            label: AppString.rescue_password_screen__email_field_label,
            hint: AppString.rescue_password_screen__email_field_hint,
            controller: _rescuePasswordViewModel.emailController,
          ),
          const SizedBox(height: 32.0),
          CTAButton(
            text: AppString.rescue_password_screen__password_request_cta_label,
            fontSize: 20.0,
            onPressed: _rescuePasswordViewModel.isButtonEnabled
                ? () {
                    _rescuePasswordViewModel.sendPasswordResetEmail(
                      onSuccessListener: () => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          getPositiveMessageSnackBar(
                            AppString
                                .rescue_password_screen__snackbar__successful_sended_email_hint,
                          ),
                        )
                      },
                      onFailureListener: (error) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          getErrorMessageSnackBar(error),
                        )
                      },
                    );
                  }
                : null,
          )
        ],
      ),
    );
  }
}
