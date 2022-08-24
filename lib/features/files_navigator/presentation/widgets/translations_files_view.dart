import 'package:flutter/material.dart';
import 'package:vido/core/domain/translations_transmitter.dart';
import 'package:vido/features/photos_translator/domain/entities/translations_file.dart';

import '../../../../app_theme.dart';
import '../../../../injection_container.dart';
class TranslationsFilesView extends StatelessWidget {
  const TranslationsFilesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return StreamBuilder<List<TranslationsFile>>(
      stream: sl<TranslationsFilesTransmitter>().translationsFiles,
      builder: (_, data){
        final translFiles = data.data ?? [];
        return Visibility(
          visible: translFiles.isNotEmpty,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimens.littleContainerHorizontalPadding
            ),
            height: dimens.getHeightPercentage(0.08),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: translFiles.map<Widget>(
                (file){
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: dimens.littleContainerVerticalPadding
                    ),
                    width: dimens.getWidthPercentage(0.3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: dimens.getWidthPercentage(0.05),
                          height: dimens.getWidthPercentage(0.05),
                          child: const CircularProgressIndicator(
                            color: AppColors.primary,                                    
                          ),
                        ),
                        SizedBox(
                          width: dimens.getWidthPercentage(0.2),
                          child: Text(
                            file.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}