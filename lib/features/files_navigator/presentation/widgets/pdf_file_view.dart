import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/core/presentation/widgets/error_panel.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';

class PdfFileView extends StatelessWidget{
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  PdfFileView({
    Key? key
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final blocState = BlocProvider.of<FilesNavigatorBloc>(context).state as OnPdfFile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.01),
        IconButton(
          onPressed: (){
            BlocProvider.of<FilesNavigatorBloc>(context).add(SelectFilesParentEvent());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.secondary,
            size: 20,
          )
        ),
        SizedBox(
          height: screenHeight * 0.7,
          width: screenWidth,
          child: (blocState is OnPdfFileLoaded)? PDFView(
            filePath: blocState.pdf.path,
            defaultPage: 0,
            swipeHorizontal: true,
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            }
          ): SizedBox(
            height: screenHeight * 0.15,
            child: ErrorPanel(
              visible: true,
              errorTitle: 'Ha ocurrido un error con el pdf',
              errorContent: (blocState as OnPdfFileError).message,
            ),
          ),
        ),
      ],
    );
  }

}