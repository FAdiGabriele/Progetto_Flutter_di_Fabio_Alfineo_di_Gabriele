import 'package:flutter/material.dart';
import 'package:offro_cibo/domain/entities/food.dart';

import '../../../../domain/providers/user_provider.dart';
import '../../../../domain/repositories/take_food_repository.dart';
import '../../../../domain/utils/request_status.dart';
import '../../../utils/ui_error.dart';

class TakeOrderSummeryViewModel extends ChangeNotifier {
  final TakeFoodRepositoryApi _takeFoodRepositoryApi;
  final UserProviderApi _userProviderApi;

  TakeOrderSummeryViewModel({
    required TakeFoodRepositoryApi takeFoodRepository,
    required UserProviderApi userProvider,
  })  : _takeFoodRepositoryApi = takeFoodRepository,
        _userProviderApi = userProvider;

  Future<void> takeOrder({
    required Food food,
    required void Function() onSuccessListener,
    required void Function(String error) onFailureListener,
  }) async {
    final String? userId = _userProviderApi.getUserId();
    if (userId == null) {
      onFailureListener(FirebaseUIError.userNotFound.message);
      return;
    }

    final foodId = food.id;
    if (foodId == null) {
      onFailureListener(UIError.genericError.message);
      return;
    }

    final resultState = await _takeFoodRepositoryApi.takeFood(
        foodId: foodId, portions: food.quantity, userId: userId);

    if (resultState is Failure) {
      final error = getErrorString(resultState.error);
      onFailureListener(error);
    } else {
      onSuccessListener();
    }
  }
}
