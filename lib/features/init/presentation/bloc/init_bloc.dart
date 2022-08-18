import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vido/features/init/presentation/use_cases/there_is_authentication.dart';

part 'init_event.dart';
part 'init_state.dart';

class InitBloc extends Bloc<InitEvent, InitState>{
  final ThereIsAuthentication thereIsAuthentication;
  InitBloc({
    required this.thereIsAuthentication
  }) : super(OnInit()){
    on<InitEvent>((event, emit)async{
      if(event is DoInitializingCheckingEvent){
        emit(OnLoadingInitializingChecks());
        final authenticationResult = await thereIsAuthentication();
        authenticationResult.fold((_){
          emit(OnUnAuthenticated());
        }, (isAuthenticated){
          if(isAuthenticated){
            emit(OnAuthenticated());
          }else{
            emit(OnUnAuthenticated());
          }
        });
      }
    });
  }

}