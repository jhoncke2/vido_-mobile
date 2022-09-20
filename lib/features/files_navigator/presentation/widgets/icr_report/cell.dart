import 'package:flutter/material.dart';

import '../../../../../app_theme.dart';
class Cell extends StatelessWidget {
  final String text;
  final bool textIsBold;
  final Color color;
  const Cell({
    required this.text,
    required this.textIsBold,
    required this.color,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Container(
      width: dimens.getWidthPercentage(0.3),
      height: dimens.getHeightPercentage(0.075),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black,
          width: 0.75
        ),
      ),
      child: Center(
        child: Text(
          text,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: dimens.normalTextSize,
            fontWeight: textIsBold? FontWeight.bold : FontWeight.normal
          ),
        ),
      ),
    );
  }
}