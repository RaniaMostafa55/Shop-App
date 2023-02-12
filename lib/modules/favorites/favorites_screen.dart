import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/favorites_model.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return (state is! ShopLoadingFavoritesDataState)
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BuildFavItem(
                          model: ShopCubit.get(context)
                              .favoritesModel!
                              .data!
                              .data![index]));
                },
                separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                itemCount:
                    ShopCubit.get(context).favoritesModel!.data!.data!.length)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class BuildFavItem extends StatelessWidget {
  final FavoritesData model;

  const BuildFavItem({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120,
        child: Row(children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                fit: BoxFit.cover,
                image: NetworkImage(model.product!.image!),
                width: 120,
                height: 120,

                // fit: BoxFit.cover,
              ),
              (model.product!.discount != 0)
                  ? Container(
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.product!.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                ),
                const Spacer(),
                Row(
                  children: [
                    (model.product!.discount != 0)
                        ? Text(
                            model.product!.oldPrice!.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          )
                        : Container(),
                    const SizedBox(width: 5),
                    Text(
                      model.product!.price!.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorites(model.product!.id!);
                          print(model.product!.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor: (ShopCubit.get(context)
                                  .favorites[model.product!.id]!)
                              ? defaultColor
                              : Colors.grey,
                          radius: 15,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 17,
                            color: Colors.white,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
