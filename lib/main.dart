import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/data_sources/firebase_auth_service.dart';
import 'data/data_sources/firebase_firestore_food_service.dart';
import 'data/data_sources/firebase_firestore_take_food_service.dart';
import 'data/data_sources/firebase_firestore_user_service.dart';
import 'data/data_sources/firebase_storage_service.dart';
import 'domain/providers/user_provider.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/shop_food_repository.dart';
import 'domain/repositories/take_food_repository.dart';
import 'domain/repositories/user_food_repository.dart';
import 'firebase_options.dart';
import 'ui/screens/edit_offer/edit_offer_screen.dart';
import 'ui/screens/edit_offer/edit_offer_view_model.dart';
import 'ui/screens/home/shop_home_content_screen/shop_home_screen.dart';
import 'ui/screens/home/shop_home_content_screen/shop_home_view_model.dart';
import 'ui/screens/home/take_order_summary_screen/take_order_summary_screen.dart';
import 'ui/screens/home/take_order_summary_screen/take_order_summery_view_model.dart';
import 'ui/screens/home/user_home_content_screen/user_home_screen.dart';
import 'ui/screens/home/user_home_content_screen/user_home_view_model.dart';
import 'ui/screens/welcome/login_screen/login_screen.dart';
import 'ui/screens/welcome/login_screen/login_viewmodel.dart';
import 'ui/screens/welcome/register_screen/register_screen.dart';
import 'ui/screens/welcome/register_screen/register_viewmodel.dart';
import 'ui/screens/welcome/rescue_password_screen/rescue_password_screen.dart';
import 'ui/screens/welcome/rescue_password_screen/rescue_password_viewmodel.dart';
import 'ui/utils/navigation_id.dart';

void main() async {
  initFirebase();

  final firebaseAuthService = FirebaseAuthService();
  final firebaseFirestoreUserService = FirebaseFirestoreUserService();
  final firebaseFirestoreFoodService = FirebaseFirestoreFoodService();
  final firebaseStorageService = FirebaseStorageService();
  final firebaseFirestoreTakeFoodService = FirebaseFirestoreTakeFoodService();

  final authRepository = AuthRepository(
    firebaseAuthService: firebaseAuthService,
    firebaseUserService: firebaseFirestoreUserService,
  );

  final shopFoodRepository = ShopFoodRepository(
    firebaseFoodService: firebaseFirestoreFoodService,
    firebaseStorageService: firebaseStorageService,
  );

  final userFoodRepository = UserFoodRepository(
    firebaseUserService: firebaseFirestoreUserService,
    firebaseFoodService: firebaseFirestoreFoodService,
  );

  final takeFoodRepository = TakeFoodRepository(
      firebaseTakeFoodService: firebaseFirestoreTakeFoodService);

  final userProvider = UserProvider();

  runApp(MyApp(
    authRepository: authRepository,
    userProvider: userProvider,
    shopFoodRepository: shopFoodRepository,
    userFoodRepository: userFoodRepository,
    takeFoodRepository: takeFoodRepository,
  ));
}

Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryApi authRepository;
  final ShopFoodRepositoryApi shopFoodRepository;
  final UserFoodRepositoryApi userFoodRepository;
  final UserProviderApi userProvider;
  final TakeFoodRepository takeFoodRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.shopFoodRepository,
    required this.userFoodRepository,
    required this.userProvider,
    required this.takeFoodRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offro Cibo',
      routes: {
        NavigationId.login_screen: (context) => ChangeNotifierProvider(
              create: (context) =>
                  LoginViewModel(authRepository: authRepository),
              child: const LoginScreenWidget(),
            ),
        NavigationId.rescue_password_screen: (context) =>
            ChangeNotifierProvider(
              create: (context) =>
                  RescuePasswordViewModel(authRepository: authRepository),
              child: const RescuePasswordScreenWidget(),
            ),
        NavigationId.register_screen: (context) => ChangeNotifierProvider(
              create: (context) =>
                  RegisterViewModel(authRepository: authRepository),
              child: const RegisterScreenWidget(),
            ),
        NavigationId.user_home_screen: (context) => ChangeNotifierProvider(
              create: (context) => UserHomeViewModel(
                userFoodRepository: userFoodRepository,
                authRepository: authRepository,
                userProvider: userProvider,
              ),
              child: const UserHomeScreenWidget(),
            ),
        NavigationId.shop_home_screen: (context) => ChangeNotifierProvider(
              create: (context) => ShopHomeViewModel(
                shopFoodRepository: shopFoodRepository,
                userProvider: userProvider,
                authRepository: authRepository,
              ),
              child: const ShopHomeScreenWidget(),
            ),
        NavigationId.edit_offer_screen: (context) => ChangeNotifierProvider(
              create: (context) => EditOfferViewModel(
                shopFoodRepository: shopFoodRepository,
                userProvider: userProvider,
              ),
              child: EditOfferScreenWidget(),
            ),
        NavigationId.take_order_summary_screen: (context) =>
            ChangeNotifierProvider(
              create: (context) => TakeOrderSummeryViewModel(
                takeFoodRepository: takeFoodRepository,
                userProvider: userProvider,
              ),
              child: TakeOrderSummaryScreenWidget(),
            ),
      },
      home: ChangeNotifierProvider(
        create: (context) => LoginViewModel(authRepository: authRepository),
        child: const LoginScreenWidget(),
      ),
    );
  }
}
