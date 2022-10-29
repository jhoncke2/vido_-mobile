// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/widgets/file_namer.dart';
import 'package:vido/features/photos_translator/presentation/widgets/pdf_file_creator.dart';
import 'package:vido/features/photos_translator/presentation/widgets/translations_file_camera_chooser.dart';
import 'package:vido/features/photos_translator/presentation/widgets/translations_file_creator.dart';
import 'package:vido/injection_container.dart';

import '../../../../globals.dart';
import '../widgets/file_type_selector.dart';

class PhotosTranslatorPage extends StatelessWidget {
  const PhotosTranslatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    final dimens = AppDimens();
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PhotosTranslatorBloc>(create: (_) => sl<PhotosTranslatorBloc>()),
            BlocProvider<AuthenticationBloc>(create: (_) => sl<AuthenticationBloc>())
          ],
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: dimens.getHeightPercentage(0.9),
                  child: BlocBuilder<PhotosTranslatorBloc, PhotosTranslatorState>(
                    builder: (context, state){
                      _managePostFrameCallBacks(context, state);
                      if(state is OnSelectingFileType){
                        return FileTypeSelector();
                      }else if(state is OnSelectingCamera){
                          return TranslationsFileCameraChooser();
                      }else if(state is OnCreatingTranslationsFile){
                        if(state is OnNamingTranslationsFile){
                          return FileNamer(canEnd: state.canEnd);
                        }else{
                          return TranslationsFileCreator();
                        }
                      }else if(state is OnCreatingFolder){
                        return FileNamer(canEnd: state.canEnd);
                      }else if(state is OnCreatingPdfFile){
                        return PdfFileCreator();
                      }else if(state is OnLoadingTranslationsError){
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              state.error,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18
                              ),
                            ),
                          ),
                        );
                      }else{
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _managePostFrameCallBacks(BuildContext context, PhotosTranslatorState state){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(state is OnPhotosTranslatorInitial){
        BlocProvider.of<PhotosTranslatorBloc>(context).add(InitFileTypeSelectionEvent());
      }else if(state is OnAppFileCreationEnded){
        Navigator.of(context).pushNamed(NavigationRoutes.filesNavigator);
      }
    });
  }
}
