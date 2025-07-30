import 'package:flutter/material.dart';

import '../../../../domain/entities/categories.dart';
import '../../../../domain/providers/user_provider.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/user_food_repository.dart';
import '../../../../domain/utils/request_status.dart';
import '../../../utils/ui_error.dart';
import '../../../utils/ui_request_status.dart';

class UserHomeViewModel extends ChangeNotifier {
  final AuthRepositoryApi _authRepository;
  final UserFoodRepositoryApi _userFoodRepository;
  final UserProviderApi _userProviderApi;

  UiRequestStatus userResultsUiRequestStatus = Inactive();
  UiRequestStatus userCounterUiRequestStatus = Inactive();

  UserHomeViewModel({
    required AuthRepositoryApi authRepository,
    required UserFoodRepositoryApi userFoodRepository,
    required UserProviderApi userProvider,
  })  : _authRepository = authRepository,
        _userFoodRepository = userFoodRepository,
        _userProviderApi = userProvider;

  Future<void> searchFood(
      String queryText, List<Categories> selectedCategories) async {
    userResultsUiRequestStatus = ShowLoading();
    notifyListeners();

    final resultState = await _userFoodRepository.searchFood(
        queryText: queryText, categories: selectedCategories);

    switch (resultState) {
      case Success():
        {
          userResultsUiRequestStatus = ShowData(resultState.data);
          break;
        }
      case Failure():
        {
          userResultsUiRequestStatus = ShowError(resultState.error);
          break;
        }
    }
    notifyListeners();
  }

  Future<void> getFoodCounter() async {
    userCounterUiRequestStatus = ShowLoading();
    notifyListeners();
    final String? userId = _userProviderApi.getUserId();
    if(userId == null){
      userCounterUiRequestStatus = ShowError(UIError.genericError.message);
      notifyListeners();
      return;
    }

    final resultState = await _userFoodRepository.getFoodCounter(userId: userId);
    switch (resultState) {
      case Success():
        {
          userCounterUiRequestStatus = ShowData(resultState.data);
          break;
        }
      case Failure():
        {
          userCounterUiRequestStatus = ShowError(resultState.error);
          break;
        }
    }
    notifyListeners();
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
