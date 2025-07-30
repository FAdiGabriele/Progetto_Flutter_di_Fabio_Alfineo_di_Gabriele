import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/get_message_snackbar.dart';
import '../../../components/text.dart';
import '../../../utils/app_string.dart';
import '../../../utils/navigation_id.dart';
import '../components/clickable_link_text.dart';
import '../../../components/cta_button.dart';
import '../components/email_input_field.dart';
import '../components/password_input_field.dart';
import '../components/welcome_screen.dart';
import 'login_viewmodel.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  late final LoginViewModel _loginViewModel = Provider.of<LoginViewModel>(context);

  @override
  Widget build(BuildContext context) {
    return WelcomeBackgroundWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubTitleText(text: AppString.login_screen__card_title),
          const SizedBox(height: 32.0),
          EmailInputField(
            controller: _loginViewModel.emailController,
            label: AppString.login_screen__email_field_label,
            hint: AppString.login_screen__email_field_hint,
          ),
          const SizedBox(height: 32.0),
          PasswordInputField(
            controller: _loginViewModel.passwordController,
            label: AppString.login_screen__password_field_label,
            hint: AppString.login_screen__password_field_hint,
          ),
          const SizedBox(height: 16.0),
          Container(
            alignment: Alignment.centerLeft,
            child: ClickableLinkText(
              onTap: () {
                Navigator.pushNamed(
                    context, NavigationId.rescue_password_screen);
              },
              text: AppString.login_screen__forgot_password_link_label,
            ),
          ),
          const SizedBox(height: 32.0),
          CTAButton(
            text: AppString.login_screen__login_cta_label,
            fontSize: 24.0,
            onPressed: () =>
                _loginViewModel.login(
              onSuccessListener: () => {
                ScaffoldMessenger.of(context).showSnackBar(
                  getPositiveMessageSnackBar(
                      AppString.login_screen__snackbar__successful_login_message),
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
          const SizedBox(height: 32.0),
          Row(
            children: [
              LeftBoldText(text: AppString.login_screen__register_hint),
              ClickableLinkText(
                onTap: () {
                  Navigator.pushNamed(context, NavigationId.register_screen);
                },
                text: AppString.login_screen__register_link_label,
              )
            ],
          )
        ],
      ),
    );
  }
}
