import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components/default_form_field.dart';

import '../../layout/cubit/cubit.dart';
import '../../shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var formKey = GlobalKey<FormState>();
          var searchController = TextEditingController();
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    DefaultFormField(
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please enter something to search";
                        } else {
                          return null;
                        }
                      },
                      onSubmitted: (text) {
                        SearchCubit.get(context).search(searchController.text);
                      },
                      controller: searchController,
                      type: TextInputType.text,
                      label: "Search..",
                      prefix: Icons.search,
                    ),
                    const SizedBox(height: 10),
                    (state is SearchLoadingState)
                        ? const LinearProgressIndicator()
                        : Container(),
                    const SizedBox(height: 10),
                    (state is SearchSuccessState)
                        ? Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: BuildSearchItem(
                                          model: SearchCubit.get(context)
                                              .searchModel!
                                              .data!
                                              .data![index]));
                                },
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Divider(
                                        thickness: 1,
                                      ),
                                    ),
                                itemCount: SearchCubit.get(context)
                                    .searchModel!
                                    .data!
                                    .data!
                                    .length),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuildSearchItem extends StatelessWidget {
  final SearchData model;

  const BuildSearchItem({super.key, required this.model});
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
                // fit: BoxFit.cover,
                image: NetworkImage(model.image!),
                width: 120,
                height: 120,

                // fit: BoxFit.cover,
              ),
              (model.discount != 0)
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
                  model.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                ),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      model.price!.toString(),
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
                          ShopCubit.get(context).changeFavorites(model.id!);
                          print(model.id);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              (ShopCubit.get(context).favorites[model.id]!)
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
