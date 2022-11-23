// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/core/presentation/widgets/error_panel.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/widgets/files_view/app_files_view.dart';
import 'package:vido/features/files_navigator/presentation/widgets/icr_report/icr_report_view.dart';
import 'package:vido/features/files_navigator/presentation/widgets/pdf_file_view.dart';
import 'package:vido/features/files_navigator/presentation/widgets/search_appearances_view.dart';
import '../../../../injection_container.dart';
import '../widgets/files_navigator_app_bar.dart';
import '../widgets/translations_files_view.dart';

class FilesNavigationPage extends StatelessWidget {
  const FilesNavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (_) => sl<AuthenticationBloc>()),
          BlocProvider<FilesNavigatorBloc>(create: (_) => sl<FilesNavigatorBloc>())
        ],
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<FilesNavigatorBloc, FilesNavigatorState>(
                builder: (blocContext, state){
                  _managePostFrameCallback(blocContext, state);
                  return Expanded(
                    child: WillPopScope(
                      onWillPop: ()async{
                        if(state is OnShowingAppFiles || state is OnPdfFile || state is SearchAppearancesView){
                          BlocProvider.of<FilesNavigatorBloc>(blocContext).add(SelectFilesParentEvent());
                        }else if(state is OnSearchAppearancesPdf){
                          BlocProvider.of<FilesNavigatorBloc>(blocContext).add(BackToSearchAppearancesEvent());
                        }else if(state is OnIcrTable){
                          BlocProvider.of<FilesNavigatorBloc>(blocContext).add(LoadInitialAppFilesEvent());
                        }
                        return false;
                      },
                      child: Column(
                        children: [
                          FilesNavigatorAppBar(),
                          (
                            (state is OnShowingAppFiles)?
                              AppFilesView():
                              (state is OnPdf)?
                                PdfFileView():
                                (state is OnSearchAppearances)?
                                  SearchAppearancesView():
                                    (state is OnIcrTable)?
                                      IcrReportView(
                                        headers: state.colsHeads, 
                                        rows: state.rows
                                      ):
                                      Expanded(
                                        child: Center(
                                          child: CircularProgressIndicator()
                                        )
                                      )
                          ),
                          (
                            (state is OnError)?
                              ErrorPanel(
                                visible: true, 
                                errorTitle: 'Ha ocurrido un error', 
                                errorContent: state.message
                              ): Container()
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
              TranslationsFilesView()
            ],
          ),
        )
      ),
    );
  }

  void _managePostFrameCallback(BuildContext context, FilesNavigatorState state){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(state is OnFilesNavigatorInitial){
        BlocProvider.of<FilesNavigatorBloc>(context).add(LoadInitialAppFilesEvent());
      }
    });
  }
}