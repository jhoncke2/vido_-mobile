import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';

class FileNamer extends StatelessWidget{
  final bool canEnd;
  const FileNamer({required this.canEnd, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        height: screenHeight * 0.35,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: screenWidth * 0.6,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Nombre del archivo'
                ),
                onChanged: (newText){
                  BlocProvider.of<PhotosTranslatorBloc>(context).add(ChangeFileNameEvent(newText));
                },
              ),
            ),
            MaterialButton(
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontSize: screenWidth * 0.0425
                ),
              ),
              color: AppColors.primary,
              onPressed: (canEnd)? (){
                BlocProvider.of<PhotosTranslatorBloc>(context).add(SaveCurrentFileNameEvent());
              } : null
            )
          ],
        ),
      ),
    );
  }

}