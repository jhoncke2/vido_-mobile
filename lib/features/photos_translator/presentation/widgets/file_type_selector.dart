import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
class FileTypeSelector extends StatelessWidget {
  const FileTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return SizedBox(
      height: dimens.getHeightPercentage(0.4),
      width: dimens.getWidthPercentage(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            color: AppColors.primary,
            padding: EdgeInsets.symmetric(
              horizontal: dimens.getWidthPercentage(0.175),
              vertical: dimens.littleContainerVerticalPadding
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text(
              'Crear Carpeta',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: dimens.subtitleTextSize
              )
            ),
            onPressed: (){
              BlocProvider.of<PhotosTranslatorBloc>(context).add(InitFolderCreationEvent());
            },
          ),
          MaterialButton(
            color: AppColors.primary,
            padding: EdgeInsets.symmetric(
              horizontal: dimens.getWidthPercentage(0.175),
              vertical: dimens.littleContainerVerticalPadding
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text(
              'Crear archivo',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: dimens.subtitleTextSize
              )
            ),
            onPressed: (){
              BlocProvider.of<PhotosTranslatorBloc>(context).add(InitTranslationsFileCreationEvent());
            },
          )
        ],
      ),
    );
  }
}