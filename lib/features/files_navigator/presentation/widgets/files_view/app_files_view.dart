// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/core/presentation/widgets/error_panel.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/widgets/files_view/file_item.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import '../../../../photos_translator/domain/entities/folder.dart';

class AppFilesView extends StatelessWidget{
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    final blocState = BlocProvider.of<FilesNavigatorBloc>(context).state;
    final selectedFilesIds = (blocState is OnIcrFilesSelection) ? 
                              blocState.filesIds : 
                              [];
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
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
              child: StreamBuilder<List<AppFile>>(
                stream: BlocProvider.of<FilesNavigatorBloc>(context).appFilesTransmitter.appFiles,
                builder: (context, snapshot){
                  final files = snapshot.data??BlocProvider.of<FilesNavigatorBloc>(context).lastAppFiles;//??BlocProvider.of<PhotosTranslatorBloc>(context).lastCompletedFiles;
                  return Padding(
                    padding: EdgeInsets.only(top: dimens.littleContainerVerticalPadding),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: GridView.count(
                        controller: scrollController,
                        crossAxisCount: 2,
                        children: [
                          FileItem(
                            icon: Icons.folder, 
                            iconColor: AppColors.iconPrimary,
                            text: '..',
                            interSpace: 5,
                            bigText: true,
                            onTap: (){
                              BlocProvider.of<FilesNavigatorBloc>(context).add(SelectFilesParentEvent());
                            },
                            onLongTap: (){},
                            isSelected: false,
                          ),
                          ...files.map(
                            (f) => FileItem(
                              icon: (f is Folder)? Icons.folder : Icons.picture_as_pdf,
                              iconColor: (f is Folder)? AppColors.iconPrimary : Colors.red[400]!,
                              text: f.name,
                              bigIcon: f is Folder,
                              onTap: (){
                                BlocProvider.of<FilesNavigatorBloc>(context).add(SelectAppFileEvent(f));
                              },
                              onLongTap: (){
                                BlocProvider.of<FilesNavigatorBloc>(context).add(LongPressFileEvent(f));
                              },
                              isSelected: selectedFilesIds.contains(f.id),
                            )
                          ).toList()],
                      ),
                    )
                  );
                }
              ),
            ),
          ),
          Visibility(
            visible: blocState is OnIcrFilesSelection,
            child: Container(
              width: dimens.getWidthPercentage(1),
              color: AppColors.backgroundSecondary,
              child: Center(
                child: SizedBox(
                  width: dimens.getWidthPercentage(0.5),
                  child: MaterialButton(
                    color: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: dimens.bigButtonHorizontalPadding
                    ),
                    child: Text(
                      'Generar ICR',
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: dimens.subtitleTextSize
                      ),
                    ),
                    onPressed: (){
                      BlocProvider.of<FilesNavigatorBloc>(context).add(GenerateIcrEvent());
                    },
                  ),
                ),
              ),
            ),
          ),
          ErrorPanel(
            visible: blocState is OnError, 
            errorTitle: 'Ha ocurrido un error',
            errorContent: (blocState is OnError)? blocState.message : ''
          )
        ],
      ),
    );
  }
}