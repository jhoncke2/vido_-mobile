// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/database_manager/presentation/bloc/database_manager_bloc.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
class PdfFileCreator extends StatelessWidget {
  final PdfFile file;
  final bool canEnd;
  PdfFileCreator({
    required this.file,
    required this.canEnd,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 0.8,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              width: screenWidth * 0.8,
              child: TextFormField(
                initialValue: file.name,
                decoration: const InputDecoration(
                  hintText: 'Name'
                ),
                onChanged: (newValue){
                  BlocProvider.of<DatabaseManagerBloc>(context).add(ChangePdfFileName(newValue));
                },
              ),
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: TextFormField(
                initialValue: file.url,
                decoration: const InputDecoration(
                  hintText: 'url'
                ),
                onChanged: (newValue){
                  BlocProvider.of<DatabaseManagerBloc>(context).add(ChangePdfUrl(newValue));
                },
              ),
            ),
            MaterialButton(
              child: const Text(
                'End creation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20
                ),
              ),
              onPressed: canEnd? (){
                BlocProvider.of<DatabaseManagerBloc>(context).add(EndPdfFileCreation());
              } : null,
            )
          ],
        ),
      ),
    );
  }
}