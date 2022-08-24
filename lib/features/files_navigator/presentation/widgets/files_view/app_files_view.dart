// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/widgets/files_view/file_item.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';
import '../../../../photos_translator/domain/entities/folder.dart';

class AppFilesView extends StatelessWidget{
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Expanded(
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
                  crossAxisCount: 3,
                  children: [
                    FileItem(
                      icon: Icons.folder, 
                      iconColor: Colors.yellow[800]!, 
                      text: '..', 
                      onTap: (){
                        BlocProvider.of<FilesNavigatorBloc>(context).add(SelectFilesParentEvent());
                      }
                    ),
                    ...files.map(
                      (f) => FileItem(
                        icon: (f is Folder)? Icons.folder : Icons.picture_as_pdf, 
                        iconColor: (f is Folder)? Colors.yellow[800]! : Colors.red[700]!, 
                        text: f.name, 
                        onTap: (){
                          BlocProvider.of<FilesNavigatorBloc>(context).add(SelectAppFileEvent(f));
                        }
                      )
                    ).toList()],
                ),
              )
            );
          }
        ),
      ),
    );
  }
}