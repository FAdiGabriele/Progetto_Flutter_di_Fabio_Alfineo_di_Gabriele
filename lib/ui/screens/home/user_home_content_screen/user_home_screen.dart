import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/categories.dart';
import '../../../../domain/entities/food.dart';
import '../../../../domain/utils/logger.dart';
import '../../../components/food_counter.dart';
import '../../../components/get_message_snackbar.dart';
import '../../../components/log_out_button.dart';
import '../../../components/search_bar.dart';
import '../../../components/upper_space.dart';
import '../../../utils/app_string.dart';
import '../../../utils/navigation_id.dart';
import '../../../utils/ui_request_status.dart';
import '../../../components/categories_list.dart';
import '../components/home_empty_screen_content.dart';
import '../components/user_product_card.dart';
import '../components/home_screen.dart';
import '../utils/home_screen_navigation_id.dart';
import 'user_home_view_model.dart';

class UserHomeScreenWidget extends StatefulWidget {
  const UserHomeScreenWidget({super.key});

  @override
  State<UserHomeScreenWidget> createState() => _UserHomeScreenWidget();
}

class _UserHomeScreenWidget extends State<UserHomeScreenWidget> {
  var searchBarHint = AppString.user_home_screen__search_bar_hint;
  static final _classTag = "UserHomeScreen";
  late final UserHomeViewModel _userHomeViewModel =
      Provider.of<UserHomeViewModel>(context);

  List<Categories> _selectedCategories = [];
  String _lastQuery = '';

  void _updateSelectedCategories(List<Categories> newSelection) {
    setState(() {
      _selectedCategories = newSelection;
      _userHomeViewModel.searchFood(_lastQuery, _selectedCategories);
    });
  }
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userHomeViewModel.getFoodCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    var contentWidget = _getContentList();
    var counter = _getCounterValue();

    return HomeScreenWidget(
      screenId: HomeScreenNavigationId.userHome,
      contentScreen: SingleChildScrollView(
        child: Column(
          children: [
            UpperSpace(),
            SizedBox(height: 22.0),
            SearchBarWidget(
              hint: searchBarHint,
              onSubmitted: (query) {
                _lastQuery = query;
                _userHomeViewModel.searchFood(_lastQuery, _selectedCategories);
              },
              onClear: () {
                _lastQuery = "";
                _userHomeViewModel.searchFood(_lastQuery, _selectedCategories);
              },
            ),
            SizedBox(height: 24.0),
            Center(
              child: CategoriesList(
                initialSelectedCategories: _selectedCategories,
                onCategoriesSelected: _updateSelectedCategories,
              ),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 360,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FoodCounter(foodQuantity: counter),
                    LogOutButton(
                      onPressed: () {
                        _userHomeViewModel.logout(onSuccessListener: () {
                          Navigator.pushNamed(
                              context, NavigationId.login_screen);
                        }, onFailureListener: (error) {
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

  String _getCounterValue() {
    final uiRequestStatus = _userHomeViewModel.userCounterUiRequestStatus;
    switch (uiRequestStatus) {
      case ShowData():
        {
          AppLogger.logger.d("$_classTag: ShowCounter");
          return uiRequestStatus.data.toString();
        }
      case ShowError():
        {
          AppLogger.logger.d("$_classTag: ErrorCounter");
          return '-';
        }
      case ShowLoading():
        {
          AppLogger.logger.d("$_classTag: WaitCounter");
          return '';
        }
      case Inactive():
        {
          AppLogger.logger.d("$_classTag: NoCounter");
          return '';
        }
    }
  }

  Widget _getContentList() {
    final uiRequestStatus = _userHomeViewModel.userResultsUiRequestStatus;
    switch (uiRequestStatus) {
      case ShowData():
        {
          AppLogger.logger.d("$_classTag: ShowData");
          List<Widget> widgetList = _convertList(uiRequestStatus.data);

          if (widgetList.isEmpty) {
            return HomeEmptyScreenContentWidget(
              screenId: HomeScreenNavigationId.userHome,
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
          return HomeEmptyScreenContentWidget(
            screenId: HomeScreenNavigationId.userHome,
          );
        }
      case Inactive():
        return HomeEmptyScreenContentWidget(
          screenId: HomeScreenNavigationId.userHome,
        );
    }
  }

  List<Widget> _convertList(List<Food> foodList) {
    return foodList
        .map((food) => UserProductCard(
              name: food.foodName,
              restaurantName: food.restaurantName,
              restaurantAddress: food.restaurantAddress,
              productionFoodDate: food.date,
              foodQuantity: food.quantity,
              imageLink: food.imageLink,
              categories: food.category,
              onCTAPressed: () {
                Navigator.pushNamed(
                    context, NavigationId.take_order_summary_screen,
                    arguments: food);
              },
            ))
        .toList();
  }
}
