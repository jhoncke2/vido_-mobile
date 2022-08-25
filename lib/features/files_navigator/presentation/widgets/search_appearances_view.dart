import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/core/presentation/widgets/error_panel.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
class SearchAppearancesView extends StatelessWidget {
  const SearchAppearancesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filesState = BlocProvider.of<FilesNavigatorBloc>(context).state as OnSearchAppearances;
    final dimens = AppDimens();
    return Expanded(
      child: (filesState is OnSearchAppearancesError)? ErrorPanel(
        visible: true, 
        errorTitle: 'Ocurrió un error con la búsqueda', 
        errorContent: filesState.message
      ) : (filesState is OnSearchAppearancesSuccessShowing)? Container(
        color: AppColors.backgroundSecondary,
        child: ListView(
          children: filesState.appearances.map<Widget>(
            (appearance) => Container(
              padding: EdgeInsets.symmetric(
                vertical: dimens.normalContainerVerticalPadding
              ),
              child: GestureDetector(
                child: Container(
                  width: dimens.getWidthPercentage(1),
                  padding: EdgeInsets.symmetric(
                    vertical: dimens.littleContainerVerticalPadding,
                    horizontal: dimens.bigContainerHorizontalPadding
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundPrimary
                  ),
                  child: Column(
                    children: [
                      Text(
                        appearance.title,
                        style: TextStyle(
                          fontSize: dimens.subtitleTextSize
                        ),
                      ),
                      Text(
                        appearance.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: dimens.normalTextSize
                        ),
                      ),
                      Visibility(
                        visible: appearance.pdfPage != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'En página ${appearance.pdfPage}',
                              style: TextStyle(
                                fontSize: dimens.littleTextSize,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: (){
                  BlocProvider.of<FilesNavigatorBloc>(context).add(SelectSearchAppearanceEvent(appearance));
                },
              ),
            )
          ).toList(),
        ),
      ) : Container()
    );
  }
}