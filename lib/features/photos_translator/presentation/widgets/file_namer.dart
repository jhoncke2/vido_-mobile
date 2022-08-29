import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';

class FileNamer extends StatelessWidget{
  final bool canEnd;
  const FileNamer({required this.canEnd, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Center(
      child: SizedBox(
        height: dimens.getHeightPercentage(0.3),
        width: dimens.getWidthPercentage(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: dimens.getWidthPercentage(0.6),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Nombre'
                ),
                onChanged: (newText){
                  BlocProvider.of<PhotosTranslatorBloc>(context).add(ChangeFileNameEvent(newText));
                },
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.bigButtonHorizontalPadding
              ),
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontSize: dimens.subtitleTextSize,
                  color: canEnd? AppColors.textPrimaryDark : AppColors.textPrimary
                ),
              ),
              color: AppColors.primary,
              onPressed: (canEnd)? (){
                BlocProvider.of<PhotosTranslatorBloc>(context).add(SaveCurrentFileNameEvent());
              } : null
            )
          ],
        ),
      ),
    );
  }

}