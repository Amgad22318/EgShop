import 'package:egshop/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

class DefaultMaterialButton extends StatelessWidget {
  final bool isUpperCase;
  final double width;
  final double radius;
  final Color background;
  final Color? splashColor;
  final VoidCallback onPressed; // voidCallback = void Function()
  final String? text;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const DefaultMaterialButton(
      {Key? key,
        required this.onPressed, this.text,
        this.width = double.infinity,
        this.isUpperCase = true,
        this.background = greyBlue3,
        this.radius = 20,
        this.child,
        this.splashColor, this.padding })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: width,
      child: MaterialButton(padding:padding ,
        elevation: 0,
        splashColor: splashColor,
        color: background,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        onPressed: onPressed,
        child: child ??
            Text(
              isUpperCase ? text!.toUpperCase() : text!,
              style: const TextStyle(color: Colors.white),
            ),
      ),
    );
  }
}
