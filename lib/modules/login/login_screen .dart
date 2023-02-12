import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/flutter_toast.dart';
import 'package:shop_app/shared/constants.dart';
import 'package:shop_app/shared/enums.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

import '../../shared/components/default_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passController = TextEditingController();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.putString(
                      key: "token", value: state.loginModel.data!.token!)
                  .then((value) {
                token = state.loginModel.data!.token!;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShopLayout(),
                    ));
              });
              // print(state.loginModel.data!.token);
              // print(state.loginModel.message);
            } else {
              showFlutterToast(
                  message: state.loginModel.message!, state: ToastStates.error);

              // print("message isssssssssss ${state.loginModel.message}");
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          "Login now to browse our hot offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 30),
                        DefaultFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email address";
                            }
                            return null;
                          },
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: "Email Address",
                          prefix: Icons.email,
                        ),
                        const SizedBox(height: 15),
                        DefaultFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Password is too short";
                            }
                            return null;
                          },
                          controller: passController,
                          type: TextInputType.visiblePassword,
                          label: "Password",
                          prefix: Icons.lock,
                          isObsecure: LoginCubit.get(context).isPassword,
                          onSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  pass: passController.text);
                            }
                          },
                          suffix: LoginCubit.get(context).suffix,
                          suffixTap: () {
                            LoginCubit.get(context).changePasswordVisibility();
                          },
                        ),
                        const SizedBox(height: 30),
                        (state is! LoginLoadingState)
                            ? MaterialButton(
                                padding: const EdgeInsets.all(8),
                                minWidth: double.infinity,
                                color: defaultColor,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        pass: passController.text);
                                  }
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ));
                                },
                                child: const Text("Register Now"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
