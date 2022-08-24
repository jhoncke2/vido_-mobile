import 'package:flutter/material.dart';

import '../../../../../app_theme.dart';
class FileItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final Function() onTap;
  const FileItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(  
            icon,
            color: iconColor,
            size: dimens.normalIconSize,
          ),
          SizedBox(height: dimens.littleVerticalSpace),
          Text(
            text,
            style: TextStyle(
              fontSize: dimens.littleTextSize
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}