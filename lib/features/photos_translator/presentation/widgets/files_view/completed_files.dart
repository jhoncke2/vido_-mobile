// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';

class CompletedFilesView extends StatelessWidget{
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Expanded(
      child: Container(
        height: dimens.getHeightPercentage(0.8),
        width: dimens.getWidthPercentage(1),
        padding: EdgeInsets.only(
          left: dimens.normalContainerHorizontalPadding,
          right: dimens.normalContainerHorizontalPadding, 
          top: dimens.normalContainerVerticalPadding,
          bottom: dimens.littleContainerVerticalPadding
        ),
        decoration: const BoxDecoration(
          color: AppColors.backgroundSecondary
        ),
        child: StreamBuilder<List<PdfFile>>(
          stream: BlocProvider.of<PhotosTranslatorBloc>(context).completedFilesStream,
          builder: (context, snapshot){
            final files = snapshot.data??BlocProvider.of<PhotosTranslatorBloc>(context).lastCompletedFiles;
            if(files.isNotEmpty){
              return Padding(
                padding: EdgeInsets.only(top: dimens.littleContainerVerticalPadding),
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
                              size: dimens.normalIconSize,
                            ),
                            SizedBox(height: dimens.littleVerticalSpace),
                            Text(
                              f.name,
                              style: TextStyle(
                                fontSize: dimens.littleTextSize
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
        ),
      ),
    );
  }

}

/*
SizedBox(
  height: dimens.getHeightPercentage(0.075),
  width: dimens.getWidthPercentage(0.9),
  child: StreamBuilder<List<TranslationsFile>>(
    stream: BlocProvider.of<PhotosTranslatorBloc>(context).inCompletingProcessFilesStream,
    builder: (context, snapshot) {
      final files = snapshot.data??[];
      if(files.isNotEmpty){
        return SizedBox(
          width: dimens.getWidthPercentage(0.9),
          child: ListView(
            children: files.map(
              (f) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    color: Colors.grey[700],
                    size: dimens.normalIconSize,
                  ),
                  SizedBox(height: dimens.littleVerticalSpace),
                  Text(
                    f.name,
                    style: TextStyle(
                      fontSize: dimens.normalTextSize
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
*/