// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/init/presentation/bloc/init_bloc.dart';
import 'package:vido/globals.dart';
import '../../../../injection_container.dart';

class InitPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<InitBloc>(
        create: (_) => sl<InitBloc>(),
        child: SafeArea(
          child: BlocBuilder<InitBloc, InitState>(
            builder: (blocContext, state){
              _managePostFrameCallBacks(blocContext, state);
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  void _managePostFrameCallBacks(BuildContext context, InitState state){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch(state.runtimeType){
        case OnInit:
          BlocProvider.of<InitBloc>(context).add(DoInitializingCheckingEvent());
          break;
        case OnAuthenticated:
          Navigator.of(context).pushReplacementNamed(NavigationRoutes.filesNavigator);
          break;
        case OnUnAuthenticated:
          Navigator.of(context).pushReplacementNamed(NavigationRoutes.authentication);
      }
    });
  }
}