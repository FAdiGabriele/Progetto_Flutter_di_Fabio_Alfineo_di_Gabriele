import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/food.dart';
import '../../../../domain/utils/logger.dart';
import '../../../components/get_message_snackbar.dart';
import '../../../components/log_out_button.dart';
import '../../../components/text.dart';
import '../../../components/upper_space.dart';
import '../../../components/warning_dialog.dart';
import '../../../utils/app_string.dart';
import '../../../utils/navigation_id.dart';
import '../../../utils/ui_request_status.dart';
import '../components/home_empty_screen_content.dart';
import '../components/shop_product_card.dart';
import '../components/home_screen.dart';
import '../utils/home_screen_navigation_id.dart';
import 'shop_home_view_model.dart';

class ShopHomeScreenWidget extends StatefulWidget {
  const ShopHomeScreenWidget({super.key});

  @override
  State<ShopHomeScreenWidget> createState() => _ShopHomeContentScreenWidget();
}

class _ShopHomeContentScreenWidget extends State<ShopHomeScreenWidget> {
  static final _classTag = "ShopHomeContentScreen";
  late final ShopHomeViewModel _shopHomeViewModel =
      Provider.of<ShopHomeViewModel>(context);

  @override
  Widget build(BuildContext context) {
    var contentWidget = _getContentList();

    return HomeScreenWidget(
      screenId: HomeScreenNavigationId.shopHome,
      contentScreen: SingleChildScrollView(
        child: Column(
          children: [
            UpperSpace(),
            SizedBox(height: 21.0),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 360,
                  minWidth: 360,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LeftTitleText(
                      text: AppString.shop_home_screen__your_offers_label,
                    ),
                    LogOutButton(
                      onPressed: () {
                        _shopHomeViewModel.logout(
                            onSuccessListener: () {
                              Navigator.pushNamed(context, NavigationId.login_screen);
                            },
                            onFailureListener: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                getErrorMessageSnackBar(error),
                              );
                            });
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            contentWidget,
          ],
        ),
      ),
    );
  }

  Widget _getContentList() {
    final uiRequestStatus = _shopHomeViewModel.shopOffersUiRequestStatus;
    switch (uiRequestStatus) {
      case ShowData():
        {
          AppLogger.logger.d("$_classTag: ShowData");
          List<Widget> widgetList = _convertList(uiRequestStatus.data);

          if (widgetList.isEmpty) {
            return HomeEmptyScreenContentWidget(
              screenId: HomeScreenNavigationId.shopHome,
            );
          } else {
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: widgetList,
            );
          }
        }

      case ShowError():
        {
          AppLogger.logger.d("$_classTag: ShowError");
          return HomeEmptyScreenContentWidget(
            screenId: HomeScreenNavigationId.shopHome,
          );
        }
      case ShowLoading():
        {
          AppLogger.logger.d("$_classTag: ShowLoading");
          return Container();
        }
      case Inactive():
        return Container();
    }
  }

  List<Widget> _convertList(List<Food> foodList) {
    return foodList
        .map((food) => ShopProductCard(
              food: food,
              onDeleteButtonPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return WarningDialog(
                        message: AppString
                            .shop_home_screen__delete_food_dialog_title,
                        onConfirm: () {
                          _shopHomeViewModel.deleteOffer(
                            offerId: food.id,
                            onSuccessListener: () {
                              Navigator.pushNamed(
                                  context, NavigationId.shop_home_screen);
                            },
                            onFailureListener: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                getErrorMessageSnackBar(error),
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        confirmButtonText: AppString
                            .shop_home_screen__delete_food_dialog_confirm_button_label,
                        cancelButtonText: AppString
                            .shop_home_screen__delete_food_dialog_cancel_button_label,
                      );
                    });
              },
              onEditButtonPressed: () {
                Navigator.pushNamed(context, NavigationId.edit_offer_screen,
                    arguments: food);
              },
            ))
        .toList();
  }
}
