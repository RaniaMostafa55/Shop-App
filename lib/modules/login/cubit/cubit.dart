import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  LoginModel? loginModel;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = (isPassword)
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }

  void userLogin({required String email, required String pass}) {
    emit(LoginLoadingState());
    DioHelper.postData(url: login, data: {"email": email, "password": pass})
        .then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      // print(loginModel!.data!.email);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
      print("Errorrrrrrrrrrrrrrr");
    });
  }
}
