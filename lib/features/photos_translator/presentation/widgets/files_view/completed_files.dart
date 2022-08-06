// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';

class CompletedFilesView extends StatelessWidget{
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.5,
      width: screenWidth,
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02, 
        top: screenHeight * 0.02,
        bottom: screenHeight * 0.01
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: screenHeight * 0.4,
            child: StreamBuilder<List<PdfFile>>(
              stream: BlocProvider.of<PhotosTranslatorBloc>(context).completedFilesStream,
              builder: (context, snapshot){
                final files = snapshot.data??BlocProvider.of<PhotosTranslatorBloc>(context).lastCompletedFiles;
                if(files.isNotEmpty){
                  return Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.0025),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: GridView.count(
                        controller: scrollController,
                        crossAxisCount: 3,
                        children: files.map(
                          (f) => GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(  
                                  Icons.picture_as_pdf,
                                  color: Colors.red[700],
                                  size: screenWidth * 0.06,
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  f.name,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035
                                  ),
                                )
                              ],
                            ),
                            onTap: (){
                              BlocProvider.of<PhotosTranslatorBloc>(context).add(SelectPdfFileEvent(f));
                            },
                          )
                        ).toList(),
                      ),
                    )
                  );
                }else{
                  return Container();
                }
              }
            )
          ),
          SizedBox(
            height: screenHeight * 0.07,
            width: screenWidth * 0.9,
            child: StreamBuilder<List<TranslationsFile>>(
              stream: BlocProvider.of<PhotosTranslatorBloc>(context).inCompletingProcessFilesStream,
              builder: (context, snapshot) {
                final files = snapshot.data??[];
                if(files.isNotEmpty){
                  return SizedBox(
                    width: screenWidth * 0.9,
                    child: ListView(
                      children: files.map(
                        (f) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.grey[700],
                              size: screenWidth * 0.06,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              f.name,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035
                              ),
                            )
                          ],
                        )
                      ).toList(),
                    )
                    
                  );
                }else{
                  return Container();
                }
              }
            )
          )
        ],
      ),
    );
  }

}