import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/widgets/files_view/completed_files.dart';
class FilesView extends StatelessWidget {
  final List<TranslationsFile> files;
  const FilesView({
    required this.files,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final blocState = BlocProvider.of<PhotosTranslatorBloc>(context).state as OnTranslationsFilesLoaded;
    return Column(
      children: [
        CompletedFilesView(),
        MaterialButton(
          child: const Text('Iniciar Creación de archivo'),
          color: AppColors.primary,
          onPressed: (){
            BlocProvider.of<PhotosTranslatorBloc>(context).add(InitTranslationsFileEvent());
          },
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<List<TranslationsFile>>(
                stream: BlocProvider.of<PhotosTranslatorBloc>(context).uncompletedFilesStream,
                builder: (context, snapshot) {
                  return Container(
                    height: screenHeight * 0.375,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.075
                    ),
                    child: ListView(
                      children: (snapshot.data??blocState.uncompletedFiles).map<Widget>(
                        (file){
                          //final finishedEntities = file.translations.where((t) => t.text != null && t.text!.isNotEmpty).length;
                          //final finishedEntitiesWidth = finishedEntities / file.translations.length;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.0025
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Container(
                                //  height: 15,
                                //  width: screenWidth * 0.5 * finishedEntitiesWidth,
                                //  color: Colors.blue[200],
                                //),
                                //Container(
                                //  height: 15,
                                //  width: screenWidth * 0.5 * (1 - finishedEntitiesWidth),
                                //  color: Colors.blueGrey[200],
                                //),
                                SizedBox(
                                  width: screenWidth * 0.05,
                                  height: screenWidth * 0.05,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primary,                                    
                                  ),
                                ),
                                //Text(
                                //  '$finishedEntities/${file.translations.length}'
                                //)
                                SizedBox(
                                  width: screenWidth * 0.75,
                                  child: Text(
                                    file.name,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 17
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      ).toList(),
                    ),
                  );
                }
              ),
            ],
          ),
        )
      ],
    );
  }
}