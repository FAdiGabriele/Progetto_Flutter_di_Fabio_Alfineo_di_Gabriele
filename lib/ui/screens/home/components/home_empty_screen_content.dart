import 'package:flutter/material.dart';
import 'package:offro_cibo/ui/utils/app_string.dart';

import '../../../components/text.dart';
import '../../../utils/asset_location.dart';
import '../utils/home_screen_navigation_id.dart';

class HomeEmptyScreenContentWidget extends StatelessWidget {
  final HomeScreenNavigationId screenId;

  const HomeEmptyScreenContentWidget({super.key, required this.screenId});

  @override
  Widget build(BuildContext context) {
    final content = screenId == HomeScreenNavigationId.userHome
        ? getUserHomeEmptyScreenContent()
        : getShopHomeEmptyScreenContent();
    return SizedBox(
      width: 360,
      child: content,
    );
  }

  Widget getUserHomeEmptyScreenContent() {
    return Column(
      children: [
        Center(
            child: SizedBox(
                child: Image.asset(AssetLocation.userArtworkPngLocation))),
        SubTitleText(text: AppString.user_home_screen__empty_screen_body),
      ],
    );
  }

  Widget getShopHomeEmptyScreenContent() {
    return Column(
      children: [
        SubTitleText(text: AppString.shop_home_screen__empty_screen_body),
        Center(child: Image.asset(AssetLocation.shopArtworkPngLocation)),
      ],
    );
  }
}
