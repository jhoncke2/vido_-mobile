// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/database_manager/presentation/bloc/database_manager_bloc.dart';
import 'package:vido/features/database_manager/presentation/widgets/pdf_file_creator.dart';
import 'package:vido/features/database_manager/presentation/widgets/pdf_files_view.dart';
import '../../../../injection_container.dart';

class DatabaseManagerPage extends StatelessWidget {
  DatabaseManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<DatabaseManagerBloc>(
          create: (_)=>sl<DatabaseManagerBloc>(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Database Manager',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22
                ),
              ),
              BlocBuilder<DatabaseManagerBloc, DatabaseManagerState>(
                builder: (blocContext, state){
                  _managePostFrameEvents(blocContext, state);
                  if(state is OnPdfFilesLoaded){
                    return PdfFilesView(files: state.files);
                  }else if(state is OnCreatingPdfFile){
                    return PdfFileCreator(file: state.file, canEnd: state.canEnd);
                  }else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  void _managePostFrameEvents(BuildContext context, DatabaseManagerState state){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(state is DatabaseManagerInitial){
        BlocProvider.of<DatabaseManagerBloc>(context).add(LoadPdfFiles());
      }
    });
  }
}