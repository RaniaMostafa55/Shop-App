import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';

import '../../../models/Login_model.dart';
import '../../../shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  LoginModel? registerModel;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = (isPassword)
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ChangeRegisterPasswordVisibilityState());
  }

  void userRegister(
      {required String email,
      required String pass,
      required String name,
      required String phone}) {
    emit(RegisterLoadingState());
    DioHelper.postData(url: register, data: {
      "email": email,
      "password": pass,
      "name": name,
      "phone": phone
    }).then((value) {
      print(value.data);
      registerModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(registerModel!));
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
      print("Errorrrrrrrrrrrrrrr");
    });
  }
}
