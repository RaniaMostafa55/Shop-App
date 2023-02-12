import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';

import '../../models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BuildCategoryItem(
                      model: ShopCubit.get(context)
                          .categoriesModel!
                          .data!
                          .data![index]));
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount:
                ShopCubit.get(context).categoriesModel!.data!.data!.length);
      },
    );
  }
}

class BuildCategoryItem extends StatelessWidget {
  final CategoryData model;

  const BuildCategoryItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: NetworkImage(model.image!),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 20),
        Text(
          model.name!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios)
      ],
    );
  }
}
