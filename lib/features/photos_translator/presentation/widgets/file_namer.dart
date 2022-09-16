import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';

class FileNamer extends StatelessWidget{
  final bool canEnd;
  const FileNamer({required this.canEnd, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    final blocState = (BlocProvider.of<PhotosTranslatorBloc>(context).state as OnCreatingAppFile);
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
            (blocState is OnCreatingTranslationsFile?
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: dimens.normalContainerVerticalPadding
                ),
                child: Column(
                  children: [
                    Text(
                      'Tecnología para lectura de imágenes',
                      style: TextStyle(
                        fontSize: dimens.littleTextSize
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: dimens.getWidthPercentage(0.25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ocr',
                                style: TextStyle(
                                  fontSize: dimens.normalTextSize
                                )
                              ),
                              Radio(
                                value: TranslationProccessType.ocr,
                                groupValue: blocState.proccessType,
                                onChanged: (TranslationProccessType? proccessType){
                                  BlocProvider.of<PhotosTranslatorBloc>(context).add(ChangeFileProccessTypeEvent(proccessType!));
                                },
                                
                              )
                            ]
                          ),
                        ),
                        SizedBox(
                          width: dimens.getWidthPercentage(0.25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Icr',
                                style: TextStyle(
                                  fontSize: dimens.normalTextSize
                                )
                              ),
                              Radio(
                                value: TranslationProccessType.icr,
                                groupValue: blocState.proccessType,
                                onChanged: (TranslationProccessType? proccessType){
                                  BlocProvider.of<PhotosTranslatorBloc>(context).add(ChangeFileProccessTypeEvent(proccessType!));
                                },
                                
                              )
                            ]
                          ),
                        )
                        
                      ],
                    ),
                  ],
                ),
              ) : Container()
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
                BlocProvider.of<PhotosTranslatorBloc>(context).add(EndFileInitializingEvent());
              } : null
            )
          ],
        ),
      ),
    );
  }

}