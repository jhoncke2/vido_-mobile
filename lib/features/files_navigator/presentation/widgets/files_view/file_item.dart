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
  final Function() onLongTap;
  final bool isSelected;
  const FileItem({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.onTap,
    required this.onLongTap,
    required this.isSelected,
    this.bigText = false,
    this.bigIcon = true,
    this.interSpace,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Container(
      margin: const EdgeInsets.all(2),
      height: dimens.getHeightPercentage(0.2),
      child: Center(
        child: InkWell(
          child: SizedBox(
            height: dimens.getHeightPercentage(
              text.length > 9? 0.2 : 0.16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected? AppColors.primary : Colors.transparent,
                      width: 2
                    )
                  ),
                  padding: EdgeInsets.all( isSelected? 10 : 0),
                  child: Icon(  
                    icon,
                    color: iconColor,
                    size: bigIcon? dimens.bigIconSize : dimens.normalIconSize,
                  ),
                ),
                SizedBox(
                   height: (isSelected)? 10
                            : interSpace ?? dimens.littleVerticalSpace
                ),
                SizedBox(
                  width: dimens.getWidthPercentage(0.3),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: bigText? dimens.titleTextSize : dimens.normalTextSize
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: onTap,
          onLongPress: onLongTap
        ),
      ),
    );
  }
}