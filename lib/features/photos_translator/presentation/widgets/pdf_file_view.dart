import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';

class PdfFileView extends StatelessWidget{
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  final PdfFile file;
  final File pdf;
  PdfFileView({
    required this.file,
    required this.pdf,
    Key? key
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.01),
        IconButton(
          onPressed: (){
            BlocProvider.of<PhotosTranslatorBloc>(context).add(LoadTranslationsFilesEvent());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.secondary,
            size: 20,
          )
        ),
        SizedBox(
          height: screenHeight * 0.9,
          width: screenWidth,
          child: PDFView(
            filePath: pdf.path,
            defaultPage: 1,
            swipeHorizontal: true,
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            }
          ),
        ),
      ],
    );
  }

}