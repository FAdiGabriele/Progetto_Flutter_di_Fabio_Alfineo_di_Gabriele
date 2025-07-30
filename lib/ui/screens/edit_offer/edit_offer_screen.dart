import 'package:flutter/material.dart';
import 'package:offro_cibo/domain/utils/logger.dart';
import 'package:offro_cibo/ui/components/upper_space.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/food.dart';
import '../../components/app_back_button.dart';
import '../../components/categories_list.dart';
import '../../components/confirmation_dialog.dart';
import '../../components/cta_button.dart';
import '../../components/get_message_snackbar.dart';
import '../../components/text.dart';
import '../../utils/app_color.dart';
import '../../utils/app_string.dart';
import '../../utils/navigation_id.dart';
import '../home/components/bottom_navigation_bar.dart';
import '../home/utils/home_screen_navigation_id.dart';
import 'components/image_bottom_sheet.dart';
import 'components/image_picker_button.dart';
import 'components/underlined_text_form_field.dart';
import 'components/number_chip.dart';
import 'components/numeric_underlined_text_form_field.dart';
import 'edit_offer_view_model.dart';

class EditOfferScreenWidget extends StatefulWidget {
  const EditOfferScreenWidget({super.key});

  @override
  State<EditOfferScreenWidget> createState() => _EditOfferScreenWidgetState();
}

class _EditOfferScreenWidgetState extends State<EditOfferScreenWidget> {
  static final _classTag = "EditOfferScreen";
  late final EditOfferViewModel _editOfferViewModel =
      Provider.of<EditOfferViewModel>(context);

  Food? food;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Food) {
      if (food == null) {
        food = arguments;
        AppLogger.logger
            .d("$_classTag -> Food arrived: ${food?.foodName}");
        AppLogger.logger
            .d("$_classTag -> Food arrived: ${food?.id}");
        _editOfferViewModel.setDefaultValue(food);
      }
    }

    return Scaffold(
      backgroundColor: AppColor.backgroundWhite,
      bottomNavigationBar: getBottomBarApp(
          selectedIndex: HomeScreenNavigationId.shopHome.id,
          updateSelectedIndex: (newIndex) {
            if (newIndex == HomeScreenNavigationId.shopHome.id) {
              Navigator.pushNamed(context, NavigationId.shop_home_screen);
            } else {
              Navigator.pushNamed(context, NavigationId.user_home_screen);
            }
          }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpperSpace(alternativeHeight: 24.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: 4.0),
                AppBackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                TitleText(
                  text: AppString.add_offer_screen__add_offer_title,
                ),
                Spacer(),
                SizedBox(width: 40.0),
                SizedBox(width: 4.0),
              ],
            ),
            getContent(),
          ],
        ),
      ),
    );
  }

  Widget getContent() {
    bool isEditOfferScreen = food != null;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            LeftSubTitleText(
                text: AppString.add_offer_screen__product_name_label),
            SizedBox(height: 16.0),
            UnderlinedTextFormField(
              controller: _editOfferViewModel.nameController,
              isTitle: true,
            ),
            SizedBox(height: 16.0),
            LeftSubTitleText(
                text: AppString.add_offer_screen__product_categories_label),
            SizedBox(height: 16.0),
            CategoriesList(
              initialSelectedCategories: _editOfferViewModel.selectedCategories,
              onCategoriesSelected: (selectedCategoriesList) {
                _editOfferViewModel.selectedCategories = selectedCategoriesList;
              },
            ),
            SizedBox(height: 16.0),
            LeftSubTitleText(
                text:
                    AppString.add_offer_screen__product_portions_number_label),
            SizedBox(height: 16.0),
            NumberChip(
              controller: _editOfferViewModel.portionNumberController,
            ),
            SizedBox(height: 16.0),
            LeftSubTitleText(
                text: AppString.add_offer_screen__product_date_label),
            SizedBox(height: 16.0),
            _buildDateRow(),
            SizedBox(height: 16.0),
            LeftSubTitleText(
                text: AppString.add_offer_screen__restaurant_name_label),
            SizedBox(height: 16.0),
            UnderlinedTextFormField(
              controller: _editOfferViewModel.restaurantNameController,
            ),
            SizedBox(height: 16.0),
            LeftSubTitleText(
                text: AppString.add_offer_screen__restaurant_address_label),
            SizedBox(height: 16.0),
            UnderlinedTextFormField(
              controller: _editOfferViewModel.restaurantAddressController,
            ),
            SizedBox(height: 16.0),
            LeftSubTitleText(text: AppString.add_offer_screen__add_image_label),
            SizedBox(height: 16.0),
            ImagePickerWidget(
              onPressed: () {
                addImageBottomSheet(
                  context,
                  _editOfferViewModel.imagePickerNotifier,
                );
              },
              notifier: _editOfferViewModel.imagePickerNotifier,
            ),
            SizedBox(height: 36.0),
            CTAButton(
              text: AppString.add_offer_screen__save_button_label,
              onPressed: () {
                if (!isEditOfferScreen) {
                  _editOfferViewModel.checkBeforeSaveProduct(
                    onSuccessListener: (food) {
                      _createDialog(food);
                    },
                    onFailureListener: _failureListener,
                  );
                } else {
                  _editOfferViewModel.editProduct(
                    offerId: food?.id,
                    onSuccessListener: _getOnSuccessListener(
                      AppString.edit_offer_screen__snackbar__successful_message,
                    ),
                    onFailureListener: _failureListener,
                  );
                }
              },
              fontSize: 20,
            )
          ],
        ));
  }

  Widget _buildDateRow(){
    return Row(
      children: [
        NumericUnderlinedTextFormField(
            controller: _editOfferViewModel.dayController,
            hint: AppString.add_offer_screen__product_date_day_hint),
        SizedBox(width: 6.0),
        GreenSlashText(),
        SizedBox(width: 6.0),
        NumericUnderlinedTextFormField(
            controller: _editOfferViewModel.monthController,
            hint: AppString.add_offer_screen__product_date_month_hint),
        SizedBox(width: 6.0),
        GreenSlashText(),
        SizedBox(width: 6.0),
        NumericUnderlinedTextFormField(
            controller: _editOfferViewModel.yearController,
            hint: AppString.add_offer_screen__product_date_year_hint),
      ],
    );
  }

  _createDialog(Food food) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            message: AppString.add_offer_screen__dialog_message,
            confirmButtonText:
                AppString.add_offer_screen__dialog_confirm_button_label,
            cancelButtonText:
                AppString.add_offer_screen__dialog_cancel_button_label,
            onConfirm: () {
              _editOfferViewModel.addProduct(
                  food: food,
                  onSuccessListener: _getOnSuccessListener(
                    AppString.add_offer_screen__snackbar__successful_message,
                  ),
                  onFailureListener: (error) {
                    Navigator.pop(context);
                    _failureListener.call(error);
                  });
            },
            onCancel: () {
              Navigator.pop(context);
            },
          );
        });
  }

  _getOnSuccessListener(String snackBarMessage) {
    return () {
      ScaffoldMessenger.of(context).showSnackBar(
        getPositiveMessageSnackBar(snackBarMessage),
      );

      Navigator.pushNamed(context, NavigationId.shop_home_screen);
    };
  }

  _failureListener(error) {
    AppLogger.logger.d("Tried to create a food error: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      getErrorMessageSnackBar(error),
    );
  }
}
