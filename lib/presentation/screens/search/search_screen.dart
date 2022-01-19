import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/business_logic/home_cubit/states.dart';
import 'package:egshop/business_logic/search_cubit/search_cubit.dart';
import 'package:egshop/presentation/views/build_fav_and_search_product.dart';
import 'package:egshop/presentation/views/components.dart';
import 'package:egshop/presentation/widgets/default_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  late SearchCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => SearchCubit(),
  child: BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        cubit = SearchCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            cubit.searchModel = null;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('EgShop'),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: searchFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 16, end: 16, top: 8),
                      child: DefaultFormField(
                        controller: searchController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Search can not be empty';
                          }
                        },
                        labelText: 'Search',
                        prefixIcon: Icons.search,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (searchText) {
                          if (searchFormKey.currentState!.validate()) {
                            cubit.getSearchData(searchText: searchText);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ConditionalBuilder(
                      condition: cubit.searchModel != null &&
                          GlobalCubit.get(context).favorites.isNotEmpty,
                      fallback: (context) {
                        if (state is ShopLoadingSearchState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Center(
                              child: Image.asset('assets/image/app logo.png'));
                        }
                      },
                      builder: (context) => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BuildFavAndSearchProduct(
                              model:
                                  cubit.searchModel!.data!.searchData![index],
                              withOutDiscount: false,cubit: cubit,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              listViewSeparator(),
                          itemCount:
                              cubit.searchModel!.data!.searchData!.length),
                    )
                  ],
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
