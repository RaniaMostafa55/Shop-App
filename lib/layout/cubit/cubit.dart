import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/shared/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../modules/categories/categories_screen.dart';
import '../../modules/favorites/favorites_screen.dart';
import '../../modules/settings/settings_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen()
  ];
  Map<int, bool> favorites = {};
  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: home, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      print("Doneeeeeeeeeeee ${homeModel!.data!.banners![0].image}");
      for (var element in homeModel!.data!.products!) {
        favorites.addAll({element.id!: element.inFavorites!});
      }
      print(favorites);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState(error));
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    DioHelper.getData(url: categories).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      print("Doneeeeeeeeeeee ${categoriesModel!.data!.data![0].name}");
      emit(ShopSuccessCategoryDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoryDataState(error));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int id) {
    favorites[id] = !favorites[id]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(url: favoritess, data: {"product_id": id}, token: token)
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[id] = !favorites[id]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      emit(ShopErrorChangeFavoritesState(error));
    });
  }

  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(ShopLoadingFavoritesDataState());
    DioHelper.getData(url: favoritess, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print("Doneeeeeeeeeeee ${favoritesModel!.data!.data![0].product}");
      emit(ShopSuccessFavoritesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorFavoritesDataState(error));
    });
  }

  LoginModel? userModel;
  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(url: profile, token: token).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print("Yessssssssssssssssssssss ${userModel!.data!.id}");
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState(error));
    });
  }

  void updateUserData(
      {required String name, required String email, required String phone}) {
    emit(ShopLoadingUpdateUserDataState());
    DioHelper.putData(
        url: update,
        token: token,
        data: {"name": name, "email": email, "phone": phone}).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print("Yessssssssssssssssssssss ${userModel!.data!.phone}");
      emit(ShopSuccessUpdateUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserDataState(error));
    });
  }
}
