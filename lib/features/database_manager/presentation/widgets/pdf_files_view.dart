import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/database_manager/presentation/bloc/database_manager_bloc.dart';
import 'package:vido/features/photos_translator/domain/entities/pdf_file.dart';
class PdfFilesView extends StatelessWidget {
  final scrollController = ScrollController();
  final List<PdfFile> files;
  PdfFilesView({
    required this.files,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: screenHeight * 0.75,
          width: screenWidth,
          child: Scrollbar(
            controller: scrollController,
            child: ListView(
              controller: scrollController,
              children: files.map<Widget>(
                (f) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      f.name,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 19
                      )
                    ),
                    Text(
                      f.url,
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 17
                      )
                    )
                  ],
                )
              ).toList(),
              
            ),
          ),
        ),
        MaterialButton(
          child: const Text(
            'New pdf file',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20
            ),
          ),
          onPressed: (){
            BlocProvider.of<DatabaseManagerBloc>(context).add(InitPdfFileCreation());
          },
        )
      ],
    );
  }
}