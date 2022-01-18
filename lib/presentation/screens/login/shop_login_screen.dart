import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/login_cubit/login_cubit.dart';
import 'package:egshop/business_logic/login_cubit/login_states.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/enums.dart';
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/presentation/views/components.dart';
import 'package:egshop/presentation/widgets/Default_text_button.dart';
import 'package:egshop/presentation/widgets/default_form_field.dart';
import 'package:egshop/presentation/widgets/default_material_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  late ShopLoginCubit cubit;

  ShopLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
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
          cubit = ShopLoginCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Image(
                          fit: BoxFit.fitHeight,
                          height: 200,
                          width: double.infinity,
                          alignment: Alignment.center,
                          image: AssetImage('assets/image/app logo.png')),
                      Text('LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black)),
                      Text('Login now to browse our offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey)),
                      const SizedBox(
                        height: 30,
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
                        height: 30,
                      ),
                      ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => DefaultMaterialButton(
                                onPressed: () {
                                  if (loginFormKey.currentState!.validate()) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'Login',
                                isUpperCase: true,
                              ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator())),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          DefaultTextButton(
                            text: 'register now',
                            onPressed: () {
                              Navigator.of(context).pushNamed('/register');
                            },
                          )
                        ],
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
