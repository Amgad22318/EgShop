import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final String labelText;
  final TextInputType keyboardType;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final void Function()? suffixIconOnPressed;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? initialValue;
  final Color? suffixIconColor;

  const DefaultFormField(
      {Key? key,
        required this.controller,
        required this.validator,
        this.onTap,
        required this.labelText,
        required this.keyboardType,
        this.onFieldSubmitted,
        this.onEditingComplete,
        this.onChanged,
        this.obscureText = false,
        this.suffixIconOnPressed,
        this.prefixIcon,
        this.suffixIcon,
        this.initialValue,
        this.suffixIconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = BlocProvider.of<GlobalCubit>(context).isDark;
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      onTap: onTap,
      obscureText: obscureText,
      style: TextStyle(color: isDark ? Colors.white : greyBlue3),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.white : defaultGrey)),
        labelStyle: TextStyle(color: isDark ? Colors.white : Colors.grey),
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.white : greyBlue3)),
        floatingLabelStyle: TextStyle(color: isDark ? Colors.white : greyBlue3),
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: IconButton(
          onPressed: suffixIconOnPressed,
          icon: Icon(
            suffixIcon,
            color: suffixIconColor,
          ),
        ),
      ),
    );
  }
}
