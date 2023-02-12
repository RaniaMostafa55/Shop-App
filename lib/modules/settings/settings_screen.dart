import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';

import '../../shared/components/default_form_field.dart';
import '../../shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel!.data;
        nameController.text = model!.name!;
        emailController.text = model.email!;
        phoneController.text = model.phone!;
        return (ShopCubit.get(context).userModel != null)
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      (state is ShopLoadingUpdateUserDataState)
                          ? const LinearProgressIndicator()
                          : Container(),
                      const SizedBox(height: 20),
                      DefaultFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Name must not be empty";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          type: TextInputType.name,
                          label: "Name",
                          prefix: Icons.person),
                      const SizedBox(height: 20),
                      DefaultFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Email must not be empty";
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: "Email Address",
                          prefix: Icons.email),
                      const SizedBox(height: 20),
                      DefaultFormField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Phone must not be empty";
                            } else {
                              return null;
                            }
                          },
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: "Phone Number",
                          prefix: Icons.phone),
                      const SizedBox(height: 20),
                      MaterialButton(
                        padding: const EdgeInsets.all(8),
                        minWidth: double.infinity,
                        color: defaultColor,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).updateUserData(
                                email: emailController.text,
                                name: nameController.text,
                                phone: phoneController.text);
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
