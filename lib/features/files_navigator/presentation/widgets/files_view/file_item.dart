import 'package:flutter/material.dart';

import '../../../../../app_theme.dart';
class FileItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final bool bigText;
  final bool bigIcon;
  final double? interSpace;
  final Function() onTap;
  const FileItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
    this.bigText = false,
    this.bigIcon = true,
    this.interSpace,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return GestureDetector(
      child: SizedBox(
        height: dimens.getHeightPercentage(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(  
              icon,
              color: iconColor,
              size: bigIcon? dimens.bigIconSize : dimens.normalIconSize,
            ),
            SizedBox(height: interSpace ?? dimens.littleVerticalSpace),
            SizedBox(
              width: dimens.getWidthPercentage(0.3),
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: bigText? dimens.titleTextSize : dimens.subtitleTextSize
                ),
              ),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}