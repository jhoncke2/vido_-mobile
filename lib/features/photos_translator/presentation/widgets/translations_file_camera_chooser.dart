import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
class TranslationsFileCameraChooser extends StatelessWidget {
  const TranslationsFileCameraChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Elige una cámara',
          style: TextStyle(
            fontSize: 19
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (BlocProvider.of<PhotosTranslatorBloc>(context).cameras).map(
              (cam) => MaterialButton(
                child: Text(
                  cam.lensDirection.name,
                  style: const TextStyle(
                    fontSize: 17
                  ),
                ),
                color: AppColors.primary,
                onPressed: (){
                  BlocProvider.of<PhotosTranslatorBloc>(context).add(ChooseCameraEvent(camera: cam));
                }
              )
            ).toList(),
          ),
        )
      ],
    );
  }
}