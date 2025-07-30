import 'package:flutter/material.dart';
import 'package:offro_cibo/domain/utils/request_status.dart';

import '../../../domain/entities/categories.dart';
import '../../../domain/entities/food.dart';
import '../../../domain/providers/user_provider.dart';
import '../../../domain/repositories/shop_food_repository.dart';
import '../../../domain/utils/date_validator.dart';
import '../../utils/ui_error.dart';
import 'utils/image_picker_notifier.dart';

class EditOfferViewModel extends ChangeNotifier {
  late final ShopFoodRepositoryApi _shopFoodRepositoryApi;
  late final UserProviderApi _userProviderApi;

  EditOfferViewModel({
    required ShopFoodRepositoryApi shopFoodRepository,
    required UserProviderApi userProvider,
  })  : _shopFoodRepositoryApi = shopFoodRepository,
        _userProviderApi = userProvider;

  final nameController = TextEditingController();
  List<Categories> selectedCategories = [];
  final portionNumberController = TextEditingController(text: '1');
  final dayController =
      TextEditingController(text: DateTime.now().day.toString());
  final monthController =
      TextEditingController(text: DateTime.now().month.toString());
  final yearController =
      TextEditingController(text: DateTime.now().year.toString());
  final restaurantNameController = TextEditingController();
  final restaurantAddressController = TextEditingController();
  String imageLinkController = '';
  final ImagePickerNotifier imagePickerNotifier = ImagePickerNotifier();

  @override
  void dispose() {
    nameController.dispose();
    portionNumberController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    restaurantNameController.dispose();
    restaurantAddressController.dispose();
    super.dispose();
  }

  void setDefaultValue(Food? food) {
    List<String> scorporatedDate = food != null ? food.date.split('/') : List.empty();

    nameController.text = food != null ? food.foodName : '';
    portionNumberController.text = food != null ? food.quantity.toString() : '1';
    dayController.text = scorporatedDate.isNotEmpty ? scorporatedDate.elementAt(0) : '';
    monthController.text = scorporatedDate.isNotEmpty ? scorporatedDate.elementAt(1) : '';
    yearController.text = scorporatedDate.isNotEmpty ? scorporatedDate.elementAt(2) : '';
    restaurantNameController.text = food != null ? food.restaurantName : '';
    restaurantAddressController.text = food != null ? food.restaurantAddress : '';
    selectedCategories = food != null ? food.category : [];
    imageLinkController = food != null ? food.imageLink : '';
    imagePickerNotifier.setImageFromLink(food != null ? food.imageLink : '');
    notifyListeners();
  }

  Future<void> checkBeforeSaveProduct({
    required void Function(Food food) onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    final String? userId = _userProviderApi.getUserId();
    if (userId == null) {
      onFailureListener(FirebaseUIError.userNotFound.message);
      return;
    }

    final uiError = _checkConditions();
    if (uiError != null) {
      onFailureListener(uiError.message);
      return;
    } else {
      final food = _buildNewFood(null, userId);
      onSuccessListener(food);
    }
  }

  Future<void> addProduct({
    required Food food,
    required void Function() onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    RequestStatus resultState = await _shopFoodRepositoryApi.addFood(
        food, imagePickerNotifier.imageSelected);

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }

  Future<void> editProduct({
    required String? offerId,
    required void Function() onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    if (offerId == null) {
      onFailureListener(UIError.genericError.message);
      return;
    }

    final String? userId = _userProviderApi.getUserId();
    if (userId == null) {
      onFailureListener(FirebaseUIError.userNotFound.message);
      return;
    }

    final uiError = _checkConditions();
    if (uiError != null) {
      onFailureListener(uiError.message);
      return;
    }
    final food = _buildNewFood(offerId, userId);

    RequestStatus resultState = await _shopFoodRepositoryApi.updateFood(
          food, imagePickerNotifier.imageSelected);

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }


  Food _buildNewFood(String? offerId, String userId) {
    return Food(
        id: offerId,
        foodName: nameController.text,
        category: selectedCategories,
        quantity: int.parse(portionNumberController.text),
        date:
            '${dayController.text}/${monthController.text}/${yearController.text}',
        restaurantName: restaurantNameController.text,
        restaurantAddress: restaurantAddressController.text,
        userId: userId,
        imageLink: imageLinkController,
    );
  }

  UIError? _checkConditions() {
    if (nameController.text.isEmpty) {
      return UIError.emptyName;
    }

    if (selectedCategories.isEmpty) {
      return UIError.emptyCategoryList;
    }

    if (int.tryParse(portionNumberController.text) == null) {
      return UIError.invalidQuantity;
    }

    DateTime? dateToCheck = DateValidator.getValidDateOrNull(
      yearController.text,
      monthController.text,
      dayController.text,
    );

    if (dateToCheck == null) {
      return UIError.invalidDate;
    }

    if (DateValidator.isFutureDate(dateToCheck)) {
      return UIError.futureDate;
    }

    if (restaurantNameController.text.isEmpty) {
      return UIError.emptyRestaurantName;
    }

    if (restaurantAddressController.text.isEmpty) {
      return UIError.emptyRestaurantAddress;
    }

    return null;
  }
}
