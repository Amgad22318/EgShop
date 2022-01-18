import 'package:flutter/material.dart';

class DefaultHeadlineText extends StatelessWidget {
  final String text;
  final int maxLines;
  final Color color;
  final TextStyle? textStyle;

  const DefaultHeadlineText(
      {Key? key,
        required this.text,
        this.maxLines = 1,
        this.color = Colors.black,
        required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle!.copyWith(color: color),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
