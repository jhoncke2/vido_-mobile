// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/files_navigator/presentation/bloc/files_navigator_bloc.dart';
import 'package:vido/globals.dart';

class FilesNavigatorAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final blocState = BlocProvider.of<FilesNavigatorBloc>(context).state; 
    final dimens = AppDimens();
    return Container(
      height: dimens.appBarHeight,
      padding: EdgeInsets.symmetric(
        horizontal: dimens.normalContainerHorizontalPadding
      ),
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.shadow, spreadRadius: 0.01, blurRadius: 5, offset: Offset(0, 4))
        ],
        color: AppColors.backgroundPrimary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: (blocState is OnAppFiles && blocState.parentFileCanBeCreatedOn),
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              heroTag: 'add_button',
              mini: true,
              child: Icon(
                Icons.add,
                size: dimens.littleIconSize,
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(NavigationRoutes.photosTranslator);
              },
            ),
          ),
          BlocBuilder<FilesNavigatorBloc, FilesNavigatorState>(
            builder: (_, filesNavState) => SizedBox(
              height: dimens.getHeightPercentage(0.052),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: dimens.getWidthPercentage(0.45),
                    child: TextField(
                      controller: BlocProvider.of<FilesNavigatorBloc>(context).searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(dimens.bigBorderRadius),
                            bottomLeft: Radius.circular(dimens.bigBorderRadius)
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(dimens.bigBorderRadius),
                            bottomLeft: Radius.circular(dimens.bigBorderRadius)
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: dimens.bigContainerHorizontalPadding
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Buscar",
                        fillColor: AppColors.backgroundPrimary
                      )
                    )
                  ),
                  SizedBox(
                    width: dimens.getWidthPercentage(0.11),
                    child: ElevatedButton(
                      child: SizedBox(
                        height: dimens.getHeightPercentage(0.052),
                        child: Icon(
                          (filesNavState is OnSearchAppearances)? Icons.close : Icons.search,
                          size: dimens.littleIconSize,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColors.primary
                        ),
                        overlayColor: MaterialStateProperty.all(
                          AppColors.primaryLight
                        ),
                        alignment: Alignment.centerLeft,
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(
                            top: 0,
                            bottom: 0,
                            left: dimens.getWidthPercentage(0.02),
                          )
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(dimens.bigBorderRadius),
                              bottomRight: Radius.circular(dimens.bigBorderRadius)
                            )
                          )
                        )
                      ),
                      onPressed: (filesNavState is OnSearchAppearances)? (){
                        BlocProvider.of<FilesNavigatorBloc>(context).add(RemoveSearchEvent());
                      } : (){
                        BlocProvider.of<FilesNavigatorBloc>(context).add(SearchEvent());
                      },
                    ),
                  )
                ],
              ),
            )
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (authContext, authState) {
              _managePostFrameCallBacks(authContext, authState);
              return FloatingActionButton(
                backgroundColor: AppColors.primaryDark,
                mini: true,
                heroTag: 'logout_button',
                child: Icon(
                  Icons.exit_to_app,
                  size: dimens.littleIconSize,
                ),
                onPressed: (authState is OnLoadingAuthentication)? null
                  :(){
                      BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
                },
              );
            }
          )
        ],
      ),
    );
  }

  void _managePostFrameCallBacks(BuildContext context, AuthenticationState authState){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(authState is OnUnAuthenticated){
        Navigator.of(context).pushReplacementNamed(NavigationRoutes.authentication);
      }
    });
  }
}