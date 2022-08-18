part of 'init_bloc.dart';
abstract class InitState extends Equatable{
  @override
  List<Object?> get props => [runtimeType];
}

class OnInit extends InitState{

}

class OnLoadingInitializingChecks extends InitState{

}

class OnUnAuthenticated extends InitState{

}

class OnAuthenticated extends InitState{
  
}