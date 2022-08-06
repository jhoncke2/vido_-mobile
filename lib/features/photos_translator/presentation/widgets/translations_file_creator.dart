import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
class TranslationsFileCreator extends StatelessWidget {
  const TranslationsFileCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final blocState = BlocProvider.of<PhotosTranslatorBloc>(context).state as OnInitializingTranslations;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            ///*
            Container(
              height: screenHeight * 0.725,
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
                        height: screenHeight * 0.6,
                        width: screenWidth,
                      );
                    }),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            MaterialButton(
              child: const Text('Tomar foto'),
              color: AppColors.primary,
              onPressed: blocState.canTranslate? (){
                BlocProvider.of<PhotosTranslatorBloc>(context).add(AddPhotoTranslationEvent());
              } : null,
            ),
            MaterialButton(
              child: const Text('Terminar archivo'),
              color: AppColors.secondary,
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