// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/features/photos_translator/presentation/widgets/photos_translator_app_bar.dart';
import 'package:vido/features/photos_translator/presentation/widgets/file_namer.dart';
import 'package:vido/features/photos_translator/presentation/widgets/pdf_file_view.dart';
import 'package:vido/features/photos_translator/presentation/widgets/translations_file_camera_chooser.dart';
import 'package:vido/features/photos_translator/presentation/widgets/translations_file_creator.dart';
import 'package:vido/features/photos_translator/presentation/widgets/files_view/files_view.dart';
import 'package:vido/injection_container.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PhotosTranslatorAppBar(),
              SizedBox(
                height: dimens.getHeightPercentage(0.85),
                child: BlocBuilder<PhotosTranslatorBloc, PhotosTranslatorState>(
                  builder: (context, state){
                    _managePostFrameCallBacks(context, state);
                    if(state is OnTranslationsFilesLoaded){
                      return FilesView();
                    }else if(state is OnSelectingCamera){
                        return TranslationsFileCameraChooser();
                    }else if(state is OnCreatingTranslationsFile){
                      if(state is OnNamingTranslationsFile){
                        return FileNamer(canEnd: state.canEnd);
                      }else{
                        return TranslationsFileCreator();
                      }
                    }else if(state is OnPdfFileLoaded){
                      return PdfFileView(file: state.file, pdf: state.pdf);
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
    );
  }

  void _managePostFrameCallBacks(BuildContext context, PhotosTranslatorState state){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(state is PhotosTranslatorInitial){
        BlocProvider.of<PhotosTranslatorBloc>(context).add(LoadTranslationsFilesEvent());
      }
    });
  }
}
