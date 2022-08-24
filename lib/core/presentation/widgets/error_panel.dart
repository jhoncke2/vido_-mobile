import 'package:flutter/material.dart';
import '../../../app_theme.dart';

class ErrorPanel extends StatelessWidget {
  final bool visible;
  final String errorTitle;
  final String errorContent;
  const ErrorPanel({
    required this.visible,
    required this.errorTitle,
    required this.errorContent,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.25),
          border: Border.all(
            color: Colors.redAccent,
            width: 1
          )
        ),
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: dimens.normalContainerVerticalMargin
        ),
        padding: EdgeInsets.symmetric(
          vertical: dimens.scaffoldVerticalPadding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              errorTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: dimens.normalTextSize
              ),
            ),
            Text(
              errorContent,
              style: TextStyle(
                fontSize: dimens.littleTextSize
              ),
            ),
          ],
        ),
      ),
    );
  }
}