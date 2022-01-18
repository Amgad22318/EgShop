import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/business_logic/register_cubit/register_cubit.dart';
import 'package:egshop/business_logic/register_cubit/register_states.dart';
import 'package:egshop/constants/enums.dart';
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/data/repository/home_repository.dart';
import 'package:egshop/presentation/screens/home/shop_layout.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:egshop/presentation/views/components.dart';
import 'package:egshop/presentation/widgets/default_form_field.dart';
import 'package:egshop/presentation/widgets/default_material_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ShopRegisterScreen extends StatelessWidget {
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late ShopRegisterCubit cubit;

  ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveDataSharedPreference(
                  key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                token = state.loginModel.data!.token;
                GlobalCubit.get(context).getFavoritesData();
                Navigator.of(context).pushNamedAndRemoveUntil('/home',(Route<dynamic> route) => false);
              });
            } else {
              showToastMsg(
                  msg: state.loginModel.message!,
                  toastState: ToastStates.ERROR);
            }
          }

        },
        builder: (context, state) {
          cubit = ShopRegisterCubit.get(context);

          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Image(
                          fit: BoxFit.fitHeight,
                          height: 200,
                          width: double.infinity,
                          alignment: Alignment.center,
                          image: AssetImage('assets/image/app logo.png')),
                      Text('Register',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: greyBlue2, fontSize: 24)),
                      const SizedBox(
                        height: 30,
                      ),
                      DefaultFormField(
                        controller: nameController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter your User name';
                          }
                        },
                        labelText: 'User Name',
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultFormField(
                        controller: emailController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter your email address';
                          }
                        },
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultFormField(
                        controller: phoneController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter your phone Number';
                          }
                        },
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultFormField(
                        controller: passwordController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter your Password';
                          }
                        },
                        labelText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outlined,
                        obscureText: cubit.passwordHidden,
                        suffixIcon: cubit.passwordSuffixIcon,
                        suffixIconOnPressed: () {
                          cubit.changePasswordVisibility();
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultFormField(
                        controller: confirmPasswordController,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Please enter the same Password';
                          }
                          if (text.length<6) {
                            return 'The password is at least 6 characters in length';
                          }
                           if (text != passwordController.text) {
                            return 'Please enter the same Password';
                          }

                        },
                        labelText: 'Confirm Password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock_outlined,
                        obscureText: cubit.passwordHidden,
                        suffixIcon: cubit.passwordSuffixIcon,
                        suffixIconOnPressed: () {
                          cubit.changePasswordVisibility();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopRegisterLoadingState,
                        builder:(context) =>  DefaultMaterialButton(
                          onPressed: () {
                            if (registerFormKey.currentState!.validate()) {
                              cubit.userRegister(email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);
                            }
                          },
                          text: 'register',
                          isUpperCase: true,
                        ),
                        fallback: (context) =>const Center(child: CircularProgressIndicator())),

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
