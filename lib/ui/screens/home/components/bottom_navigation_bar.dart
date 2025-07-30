import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/app_color.dart';
import '../../../utils/asset_location.dart';
import '../utils/home_screen_navigation_id.dart';

BottomAppBar getBottomBarApp(
    {required int selectedIndex, required Function(int) updateSelectedIndex}) {
  Widget profileIcon = selectedIndex == HomeScreenNavigationId.userHome.id
      ? SvgPicture.asset(AssetLocation.selectedProfileIconSvgLocation)
      : SvgPicture.asset(AssetLocation.profileIconSvgLocation);

  Widget shopIcon = selectedIndex == HomeScreenNavigationId.shopHome.id
      ? SvgPicture.asset(AssetLocation.selectedShopIconSvgLocation)
      : SvgPicture.asset(AssetLocation.shopIconSvgLocation);

  return BottomAppBar(
    shape: AutomaticNotchedShape(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
    ),
    color: AppColor.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: shopIcon,
          isSelected: selectedIndex == HomeScreenNavigationId.shopHome.id,
          onPressed: () {
            updateSelectedIndex(HomeScreenNavigationId.shopHome.id);
          },
        ),
        IconButton(
          icon: profileIcon,
          isSelected: selectedIndex == HomeScreenNavigationId.userHome.id,
          onPressed: () {
            updateSelectedIndex(HomeScreenNavigationId.userHome.id);
          },
        ),

      ],
    ),
  );
}