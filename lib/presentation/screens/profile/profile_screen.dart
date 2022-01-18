import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/business_logic/home_cubit/states.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/data/models/login_and_profile_model.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:egshop/presentation/widgets/default_form_field.dart';
import 'package:egshop/presentation/widgets/default_material_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  late ShopCubit cubit;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    cubit = ShopCubit.get(context);
    return  ConditionalBuilder(
        condition: cubit.profileModel != null,
        builder: (context) {
          UserData? profileModel = cubit.profileModel!.data;
          nameController.text = profileModel!.name;
          emailController.text = profileModel.email;
          phoneController.text = profileModel.phone;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: greyBlue2, width: 5)),
                        child: CircleAvatar(
                          radius: 100,
                          foregroundImage: NetworkImage(profileModel.image),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              side:
                                  const BorderSide(width: 2, color: greyBlue2)),
                          onPressed: () => pickImageBottomSheet(context),
                          child: const Icon(Icons.edit_outlined)),
                    ],
                  ),
                  Form(
                    key: profileFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if(cubit.state is ShopUpdateProfileLoadingState)
                          const LinearProgressIndicator(),
                          const SizedBox(
                            height: 15,
                          ),
                          DefaultFormField(
                            controller: nameController,
                            prefixIcon: Icons.person,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'User Name can not be empty';
                              }
                            },
                            labelText: 'User Name',
                            keyboardType: TextInputType.name,
                            onFieldSubmitted: (text) {
                              updateProfile();
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DefaultFormField(
                            controller: emailController,
                            prefixIcon: Icons.email,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'User Name can not be empty';
                              }
                            },
                            labelText: 'Email Address',
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (text) {
                              updateProfile();
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DefaultFormField(
                            controller: phoneController,
                            prefixIcon: Icons.phone,
                            validator: (text) {
                              if (text!.isEmpty) {
                                return 'Phone number can not be empty';
                              }
                            },
                            labelText: 'Phone',
                            keyboardType: TextInputType.phone,
                            onFieldSubmitted: (text) {
                              updateProfile();
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DefaultMaterialButton(
                            onPressed: () {
                              signOut(context);
                            },
                            text: 'Log Out',
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        fallback: (context) => const Center(child: CircularProgressIndicator()),

    );
  }

// update profile data name,email..etc
  void updateProfile() {
    if (profileFormKey.currentState!.validate()) {
      cubit.tempProfileModel = cubit.profileModel;
      cubit.updateUserProfile(
          email: emailController.text,
          phone: phoneController.text,
          name: nameController.text);
    }
  }

//update image
  Future pickImage(ImageSource source) async {
    ImagePicker()
        .pickImage(source: source, maxHeight: 2048, maxWidth: 1024)
        .then((image) {
      if (image != null) {
        cubit.tempProfileModel = cubit.profileModel;

        cubit.updateProfileImage(
            image: image,
            name: nameController.text,
            phone: phoneController.text,
            email: emailController.text);
      }
    }).catchError((error) {
      printWarning(error.toString());
    });
  }

  Future<dynamic> pickImageBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) {
          return Container(
            decoration: const BoxDecoration(
                color: greyBlue1,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0))),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsetsDirectional.only(top: 8),
            child: Wrap(children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_outlined),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ]),
          );
        });
  }
}
