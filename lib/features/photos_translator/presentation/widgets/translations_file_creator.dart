import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
class TranslationsFileCreator extends StatelessWidget {
  const TranslationsFileCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    final blocState = BlocProvider.of<PhotosTranslatorBloc>(context).state as OnInitializingTranslations;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            Container(
              height: dimens.getHeightPercentage(0.76),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color:
                      blocState.cameraController != null
                          ? Colors.redAccent
                          : Colors.grey,
                  width: 3.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: CameraPreview(
                    blocState.cameraController!,
                    child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        height: dimens.getHeightPercentage(0.6),
                        width: dimens.getWidthPercentage(1),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            MaterialButton(
              minWidth: dimens.getWidthPercentage(0.5),
              child: Text(
                'Tomar foto',
                style: TextStyle(
                  color: blocState.canTranslate? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                  fontSize: dimens.normalTextSize
                ),
              ),
              color: AppColors.primary,
              onPressed: blocState.canTranslate? (){
                BlocProvider.of<PhotosTranslatorBloc>(context).add(AddPhotoTranslationEvent());
              } : null,
            ),
            MaterialButton(
              minWidth: dimens.getWidthPercentage(0.5),
              child: Text(
                'Terminar archivo',
                style: TextStyle(
                  color: blocState.canEnd? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                  fontSize: dimens.normalTextSize
                )
              ),
              color: AppColors.primary,
              onPressed: blocState.canEnd? (){
                BlocProvider.of<PhotosTranslatorBloc>(context).add(EndTranslationsFileEvent());
              } : null,
            ),
          ],
        ),
      ),
    );
  }
}