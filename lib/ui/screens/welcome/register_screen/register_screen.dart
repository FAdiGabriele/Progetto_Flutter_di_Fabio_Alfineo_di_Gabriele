import 'package:flutter/material.dart';
import 'package:offro_cibo/ui/components/text.dart';
import 'package:provider/provider.dart';

import '../../../components/cta_button.dart';
import '../../../components/get_message_snackbar.dart';
import '../../../utils/app_string.dart';
import '../../../utils/navigation_id.dart';
import '../components/clickable_link_text.dart';
import '../components/email_input_field.dart';
import '../components/password_input_field.dart';
import '../components/username_input_field.dart';
import '../components/welcome_screen.dart';
import 'register_viewmodel.dart';

class RegisterScreenWidget extends StatefulWidget {
  const RegisterScreenWidget({super.key});

  @override
  State<RegisterScreenWidget> createState() => _RegisterScreenWidgetState();
}

class _RegisterScreenWidgetState extends State<RegisterScreenWidget> {
  late final RegisterViewModel _registerViewModel =
      Provider.of<RegisterViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return WelcomeBackgroundWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubTitleText(text: AppString.register_screen__card_title),
          const SizedBox(height: 32.0),
          EmailInputField(
            controller: _registerViewModel.emailController,
            label: AppString.register_screen__email_field_label,
            hint: AppString.register_screen__email_field_hint,
          ),
          const SizedBox(height: 16.0),
          UsernameInputField(
            controller: _registerViewModel.usernameController,
            label: AppString.register_screen__username_field_label,
            hint: AppString.register_screen__username_field_hint,
          ),
          const SizedBox(height: 32.0),
          PasswordInputField(
            controller: _registerViewModel.passwordController,
            label: AppString.register_screen__password_field_label,
            hint: AppString.register_screen__password_field_hint,
          ),
          const SizedBox(height: 16.0),
          PasswordInputField(
            controller: _registerViewModel.confirmPasswordController,
            label: AppString.register_screen__confirm_password_field_label,
            hint: AppString.register_screen__confirm_password_field_hint,
          ),
          const SizedBox(height: 32.0),
          CTAButton(
            text: AppString.register_screen__register_cta_label,
            fontSize: 24.0,
            onPressed: () => _registerViewModel.register(
              onSuccessListener: () => {
                ScaffoldMessenger.of(context).showSnackBar(
                  getPositiveMessageSnackBar(
                    AppString.register_screen__snackbar__successful_login_hint,
                  ),
                ),
                Navigator.pushNamed(context, NavigationId.user_home_screen)
              },
              onFailureListener: (error) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  getErrorMessageSnackBar(error),
                )
              },
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              LeftBoldText(text: AppString.register_screen__login_hint),
              ClickableLinkText(
                onTap: () {
                  Navigator.pushNamed(context, NavigationId.login_screen);
                },
                text: AppString.register_screen__login_link_label,
              )
            ],
          )
        ],
      ),
    );
  }
}
