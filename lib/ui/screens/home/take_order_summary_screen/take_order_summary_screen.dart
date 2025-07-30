import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/food.dart';
import '../../../../domain/utils/logger.dart';
import '../../../components/cta_button.dart';
import '../../../components/get_message_snackbar.dart';
import '../../../components/text.dart';
import '../../../components/top_image_card.dart';
import '../../../components/upper_space.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_string.dart';
import '../../../utils/asset_location.dart';
import '../../../utils/navigation_id.dart';
import '../components/home_screen.dart';
import '../utils/home_screen_navigation_id.dart';
import 'take_order_summery_view_model.dart';

class TakeOrderSummaryScreenWidget extends StatefulWidget {
  const TakeOrderSummaryScreenWidget({super.key});

  @override
  State<TakeOrderSummaryScreenWidget> createState() =>
      _TakeOrderSummaryScreenWidget();
}

class _TakeOrderSummaryScreenWidget
    extends State<TakeOrderSummaryScreenWidget> {
  static final _classTag = "TakeOrderSummaryScreen";

  late final TakeOrderSummeryViewModel _takeOrderSummeryViewModel;

  Food? food;

  @override
  Widget build(BuildContext context) {
    _takeOrderSummeryViewModel =
        Provider.of<TakeOrderSummeryViewModel>(context);
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Food) {
      if (food == null) {
        food = arguments;
        AppLogger.logger.d("$_classTag -> Food arrived: ${food?.foodName}");
        AppLogger.logger.d("$_classTag -> Food arrived: ${food?.id}");
      }
    }

    final safeFoodFromArgument = food;

    if (safeFoodFromArgument != null) {
      return HomeScreenWidget(
        screenId: HomeScreenNavigationId.userHome,
        contentScreen: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UpperSpace(),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: TitleText(
                      text: AppString.take_order_summary_screen__title,
                    ),
                  ),
                  SizedBox(height: 43.0),
                  _getContentCard(safeFoodFromArgument),
                  SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppLogger.logger
              .d("$_classTag -> Argument is null, navigating back.");
          Navigator.pushNamed(context, NavigationId.user_home_screen);
        }
      });
      return Container();
    }
  }

  Widget _getContentCard(Food food) {
    return SizedBox(
      width: 360,
      child: Card(
        color: AppColor.white,
        child: Column(
          children: [
            TopImageCard(imageLink: food.imageLink),
            SizedBox(height: 24.0),
            TitleText(text: food.foodName),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: food.category
                  .map((type) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GreenCategoryText(text: type.name),
                      ))
                  .toList(),
            ),
            SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  getRowWithIcon(
                    AssetLocation.cartIconSvgLocation,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CenteredText(
                            text: AppString
                                .take_order_summary_screen__portions_number_label),
                        CenteredBoldText(text: food.quantity.toString()),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Divider(
                    color: AppColor.black, // Color of the line
                    height: 1,
                  ),
                  SizedBox(height: 16.0),
                  getRowWithIcon(
                    AssetLocation.gpsIconSvgLocation,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RightBoldText(text: food.restaurantName),
                        RightText(text: food.restaurantAddress),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Divider(
                    color: AppColor.black, // Color of the line
                    height: 1,
                  ),
                  SizedBox(height: 16.0),
                  getRowWithIcon(
                    AssetLocation.clockIconSvgLocation,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CenteredText(
                            text: AppString
                                .take_order_summary_screen__product_date_label),
                        CenteredText(text: food.date),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  CTAButton(
                    text: AppString.take_order_summary_screen__cta_label,
                    onPressed: () {
                      _takeOrderSummeryViewModel.takeOrder(
                        food: food,
                        onSuccessListener: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            getPositiveMessageSnackBar(AppString
                                .take_order_summary_screen__successful_message),
                          );

                          Navigator.pushNamed(
                              context, NavigationId.user_home_screen);
                        },
                        onFailureListener: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            getErrorMessageSnackBar(error),
                          );

                          Navigator.pop(context);
                        },
                      );
                    },
                    fontSize: 24.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget getRowWithIcon(String assetLocation, Widget detailWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: SvgPicture.asset(assetLocation),
        ),
        detailWidget,
      ],
    );
  }
}
