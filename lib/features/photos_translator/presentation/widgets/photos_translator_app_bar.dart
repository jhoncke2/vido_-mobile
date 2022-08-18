// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/app_theme.dart';
import 'package:vido/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:vido/features/photos_translator/presentation/bloc/photos_translator_bloc.dart';
import 'package:vido/globals.dart';

class PhotosTranslatorAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final dimens = AppDimens();
    return Container(
      height: dimens.appBarHeight,
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppColors.shadow, spreadRadius: 0.01, blurRadius: 5, offset: Offset(0, 4))
        ],
        color: AppColors.backgrundPrimary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            backgroundColor: AppColors.primary,
            heroTag: 'add_button',
            mini: true,
            child: Icon(
              Icons.add,
              size: dimens.normalIconSize,
            ),
            onPressed: (){
              BlocProvider.of<PhotosTranslatorBloc>(context).add(InitTranslationsFileEvent());
            },
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (authContext, authState) {
              _managePostFrameCallBacks(authContext, authState);
              return FloatingActionButton(
                backgroundColor: AppColors.secondary,
                mini: true,
                heroTag: 'logout_button',
                child: Icon(
                  Icons.exit_to_app,
                  size: dimens.normalIconSize,
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