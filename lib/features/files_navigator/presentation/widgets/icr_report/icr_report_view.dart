import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/features/files_navigator/presentation/widgets/icr_report/cell.dart';
class IcrReportView extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  const IcrReportView({
    required this.headers,
    required this.rows,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Container(
      height: dimens.getHeightPercentage(0.85),
      padding: EdgeInsets.symmetric(
        vertical: dimens.scaffoldVerticalPadding,
        horizontal: dimens.scaffoldHorizontalPadding
      ),
      child: ListView(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: (){
                  BlocProvider.of<FilesNavigatorBloc>(context).add(LoadInitialAppFilesEvent());
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primary,
                  size: 20,
                )
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: headers.map<Widget>(
                    (h) => Cell(
                        text: h,
                        textIsBold: true,
                        color: AppColors.primarySuperLight
                      )
                  ).toList(),
                ),
                ...(){
                  final items = <Widget>[];
                  for(int i = 0; i < rows.length; i++){
                    final row = rows[i];
                    items.add(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row.map<Widget>(
                        (cell) => Cell(
                          text: cell,
                          textIsBold: false,
                          color: (i%2 == 0)? Colors.transparent : AppColors.backgroundSecondary
                        )
                      ).toList(),
                    ));
                  }
                  return items;
                }()
              ],
            ),
          ),
        ],
      ),
    );
  }
}