import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/enums.dart';
import 'package:shop_app/shared/styles/colors.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/flutter_toast.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.changeFavoritesModel.status!) {
            showFlutterToast(
                message: state.changeFavoritesModel.message!,
                state: ToastStates.error);
          }
        }
      },
      builder: (context, state) {
        return (ShopCubit.get(context).homeModel == null ||
                ShopCubit.get(context).categoriesModel == null)
            ? const Center(child: CircularProgressIndicator())
            : ProductBuilder(
                model: ShopCubit.get(context).homeModel!,
                categoriesModel: ShopCubit.get(context).categoriesModel!,
              );
      },
    );
  }
}

class ProductBuilder extends StatelessWidget {
  final HomeModel model;
  final CategoriesModel categoriesModel;
  const ProductBuilder(
      {super.key, required this.model, required this.categoriesModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model.data!.banners!
                .map((e) => Image(
                      image: NetworkImage(e.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ))
                .toList(),
            options: CarouselOptions(
                height: 250,
                initialPage: 0,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Image(
                            image: NetworkImage(
                              categoriesModel.data!.data![index].image!,
                            ),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 100,
                            color: Colors.black.withOpacity(0.8),
                            child: Text(
                              categoriesModel.data!.data![index].name!
                                  .toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: categoriesModel.data!.data!.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "New Products",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              childAspectRatio: 1.0 / 1.43,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(
                  model.data!.products!.length,
                  (index) => Container(
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.bottomStart,
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        model.data!.products![index].image!),
                                    width: double.infinity,
                                    height: 200,
                                    // fit: BoxFit.cover,
                                  ),
                                  (model.data!.products![index].discount != 0)
                                      ? Container(
                                          color: Colors.red,
                                          child: const Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'DISCOUNT',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      model.data!.products![index].name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 14, height: 1.3),
                                    ),
                                    Row(
                                      children: [
                                        (model.data!.products![index]
                                                    .discount !=
                                                0)
                                            ? Text(
                                                model.data!.products![index]
                                                    .oldPrice!
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              )
                                            : Container(),
                                        const SizedBox(width: 5),
                                        Text(
                                          model.data!.products![index].price!
                                              .toString(),
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
                                                  .changeFavorites(model.data!
                                                      .products![index].id!);
                                              print(model
                                                  .data!.products![index].id);
                                            },
                                            icon: CircleAvatar(
                                              backgroundColor:
                                                  (ShopCubit.get(context)
                                                              .favorites[
                                                          model
                                                              .data!
                                                              .products![index]
                                                              .id]!)
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
                      )),
            ),
          )
        ],
      ),
    );
  }
}
