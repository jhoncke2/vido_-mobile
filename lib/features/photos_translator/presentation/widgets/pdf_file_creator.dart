import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import '../bloc/photos_translator_bloc.dart';

class PdfFileCreator extends StatelessWidget {
  const PdfFileCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    final blocState = BlocProvider.of<PhotosTranslatorBloc>(context).state as OnCreatingPdfFile;
    return SizedBox(
      height: dimens.getHeightPercentage(0.4),
      width: dimens.getWidthPercentage(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: dimens.getWidthPercentage(0.6),
            child: TextFormField(
              initialValue: blocState.name,
              decoration: const InputDecoration(
                hintText: 'Nombre'
              ),
              onChanged: (newText){
                BlocProvider.of<PhotosTranslatorBloc>(context).add(ChangeFileNameEvent(newText));
              },
            ),
          ),
          Visibility(
            visible: blocState.pdf != null,
            child: Padding(
              padding: EdgeInsets.only(
                top: dimens.getHeightPercentage(0.02)
              ),
              child: Icon(
                Icons.picture_as_pdf,
                size: dimens.normalIconSize,
                color: Colors.redAccent,
              ),
            )
          ),
          MaterialButton(
            onPressed: (){
              BlocProvider.of<PhotosTranslatorBloc>(context).add(PickPdfEvent());
            },
            color: AppColors.secondary,
            child: Text(
              '${blocState.pdf == null?"Seleccionar": "cambiar"} archivo',
              style: TextStyle(
                fontSize: dimens.normalTextSize
              ),
            )
          ),
          MaterialButton(
            onPressed: blocState.canEnd? (){
              BlocProvider.of<PhotosTranslatorBloc>(context).add(EndPdfFileCreationEvent());
            } : null,
            color: AppColors.primary,
            child: Text(
              'Guardar',
              style: TextStyle(
                fontSize: dimens.normalTextSize,
                color: AppColors.textPrimaryDark
              ),
            )
          )
        ],
      ),
    );
  }
}