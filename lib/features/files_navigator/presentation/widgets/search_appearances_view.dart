import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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
                      SizedBox(
                        height: dimens.getHeightPercentage(0.05),
                        child: Html(
                          data: appearance.title,
                        ),
                      ),
                      SizedBox(
                        height: dimens.littleVerticalSpace,
                      ),
                      Visibility(
                        visible: appearance.text.isNotEmpty,
                        child: SizedBox(
                          height: dimens.getHeightPercentage(0.1),
                          child: Html(
                            data: appearance.text,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: appearance.pdfPage != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'En página ${appearance.pdfPage != null? appearance.pdfPage! + 1 : null}',
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