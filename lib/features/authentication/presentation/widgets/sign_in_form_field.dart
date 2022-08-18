import 'package:flutter/material.dart';
import '../../../../app_theme.dart';

class SignInFormField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool onError;
  final String errorMessage;
  const SignInFormField({
    required this.title,
    required this.controller,
    required this.textInputType,
    required this.onError,
    required this.errorMessage,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: dimens.littleTextSize
            ),
          ),
        ),
        TextFormField(
          keyboardType: textInputType,
          obscureText: (textInputType == TextInputType.text),
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        Visibility(
          visible: onError,
          child: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: dimens.littleTextSize
            ),
          )  
        )
      ],
    );
  }
}