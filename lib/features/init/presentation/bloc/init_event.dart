part of 'init_bloc.dart';

abstract class InitEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class DoInitializingCheckingEvent extends InitEvent{
  
}