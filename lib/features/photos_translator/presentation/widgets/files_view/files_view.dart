import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/widgets/files_view/completed_files.dart';
class FilesView extends StatelessWidget {
  const FilesView({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Column(
      children: [
        CompletedFilesView(),
        StreamBuilder<List<TranslationsFile>>(
          stream: BlocProvider.of<PhotosTranslatorBloc>(context).uncompletedFilesStream,
          builder: (context, snapshot) {
            final files = snapshot.data??BlocProvider.of<PhotosTranslatorBloc>(context).lastUncompletedFiles;
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.littleContainerHorizontalPadding
              ),
              height: dimens.getHeightPercentage( files.isEmpty? 0.0 : 0.08),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: (files).map<Widget>(
                  (file){
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: dimens.littleContainerVerticalPadding
                      ),
                      width: dimens.getWidthPercentage(0.3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: dimens.getWidthPercentage(0.05),
                            height: dimens.getWidthPercentage(0.05),
                            child: const CircularProgressIndicator(
                              color: AppColors.primary,                                    
                            ),
                          ),
                          SizedBox(
                            width: dimens.getWidthPercentage(0.2),
                            child: Text(
                              file.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16
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
        )
      ],
    );
  }
}