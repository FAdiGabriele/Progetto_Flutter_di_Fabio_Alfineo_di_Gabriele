import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/navigation_id.dart';
import 'add_floating_action_button.dart';
import 'bottom_navigation_bar.dart';
import '../utils/home_screen_navigation_id.dart';

class HomeScreenWidget extends StatelessWidget {
  final Widget contentScreen;
  final HomeScreenNavigationId screenId;

  const HomeScreenWidget({
    super.key,
    required this.contentScreen,
    required this.screenId,
  });

  @override
  Widget build(BuildContext context) {
    Widget fab = screenId.id == HomeScreenNavigationId.shopHome.id
        ? AddFloatingActionButton(
            onPressedListener: () {
              Navigator.pushNamed(context, NavigationId.edit_offer_screen);
            },
          )
        : Container();

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      bottomNavigationBar: getBottomBarApp(
          selectedIndex: screenId.id,
          updateSelectedIndex: (newIndex) {
            if (newIndex == HomeScreenNavigationId.shopHome.id) {
              Navigator.pushNamed(context, NavigationId.shop_home_screen);
            } else {
              Navigator.pushNamed(context, NavigationId.user_home_screen);
            }
          }),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: contentScreen,
    );
  }
}
