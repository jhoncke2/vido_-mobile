import 'package:flutter/material.dart';
import '../../../../app_theme.dart';

class LoginErrorWidget extends StatelessWidget {
  final bool visible;
  final String message;
  const LoginErrorWidget({
    required this.visible,
    required this.message,
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
              'Error de inicio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: dimens.normalTextSize
              ),
            ),
            Text(
              message,
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