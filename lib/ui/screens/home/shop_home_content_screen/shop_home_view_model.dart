import 'package:flutter/material.dart';

import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/shop_food_repository.dart';
import '../../../../domain/utils/request_status.dart';
import '../../../../domain/providers/user_provider.dart';
import '../../../utils/ui_error.dart';
import '../../../utils/ui_request_status.dart';

class ShopHomeViewModel extends ChangeNotifier {
  late final AuthRepositoryApi _authRepository;
  late final ShopFoodRepositoryApi _shopFoodRepository;
  late final UserProviderApi _userProvider;
  UiRequestStatus shopOffersUiRequestStatus = Inactive();

  ShopHomeViewModel({
    required AuthRepositoryApi authRepository,
    required ShopFoodRepositoryApi shopFoodRepository,
    required UserProviderApi userProvider,
  })  : _authRepository = authRepository,
        _shopFoodRepository = shopFoodRepository,
        _userProvider = userProvider {
    _getShopOffers();
  }

  Future<void> _getShopOffers() async {
    shopOffersUiRequestStatus = ShowLoading();
    notifyListeners();
    final String? userId = _userProvider.getUserId();
    if (userId == null) {
      shopOffersUiRequestStatus = ShowError(FirebaseUIError.userNotFound);
      notifyListeners();
      return;
    }

    final resultState = await _shopFoodRepository.getFoodListByUser(userId);

    switch (resultState) {
      case Success():
        {
          shopOffersUiRequestStatus = ShowData(resultState.data);
          break;
        }
      case Failure():
        {
          shopOffersUiRequestStatus = ShowError(resultState.error);
          break;
        }
    }
    notifyListeners();
  }

  Future<void> deleteOffer({
    required String? offerId,
    required void Function() onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    if (offerId == null) {
      onFailureListener(UIError.genericError.message);
      return;
    }

     final resultState = await _shopFoodRepository.deleteFood(offerId);

     if (resultState is Failure) {
       final error = getErrorString(resultState.error);
       onFailureListener(error);
     } else {
       onSuccessListener();
     }
  }

  Future<void> logout({
    required void Function() onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    final resultState = await _authRepository.logout();

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }
}
