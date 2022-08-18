
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';
import 'package:vido/features/init/presentation/bloc/init_bloc.dart';
import 'package:vido/features/init/presentation/use_cases/there_is_authentication.dart';
import 'init_bloc_test.mocks.dart';

late InitBloc initBloc;
late MockThereIsAuthentication thereIsAuthentication;

@GenerateMocks([
  ThereIsAuthentication
])
void main(){
  setUp((){
    thereIsAuthentication = MockThereIsAuthentication();
    initBloc = InitBloc(thereIsAuthentication: thereIsAuthentication);
  });

  group('init initializing checking', (){
    test('should call the specified methods', ()async{
      when(thereIsAuthentication()).thenAnswer((_) async => const Right(true));
      initBloc.add(DoInitializingCheckingEvent());
      await untilCalled(thereIsAuthentication());
      verify(thereIsAuthentication());
    });

    test('should emit the expected ordered states when there is authentication', ()async{
      when(thereIsAuthentication()).thenAnswer((_) async => const Right(true));
      final expectedOrderedStates = [
        OnLoadingInitializingChecks(),
        OnAuthenticated()
      ];
      expectLater(initBloc.stream, emitsInOrder(expectedOrderedStates));
      initBloc.add(DoInitializingCheckingEvent());
    });

    test('should emit the expected ordered states when there is Not authentication', ()async{
      when(thereIsAuthentication()).thenAnswer((_) async => const Right(false));
      final expectedOrderedStates = [
        OnLoadingInitializingChecks(),
        OnUnAuthenticated()
      ];
      expectLater(initBloc.stream, emitsInOrder(expectedOrderedStates));
      initBloc.add(DoInitializingCheckingEvent());
    });

    test('should emit the expected ordered states when there is an authentication failure', ()async{
      when(thereIsAuthentication()).thenAnswer((_) async => const Left(Failure(message: '', exception: AppException(''))));
      final expectedOrderedStates = [
        OnLoadingInitializingChecks(),
        OnUnAuthenticated()
      ];
      expectLater(initBloc.stream, emitsInOrder(expectedOrderedStates));
      initBloc.add(DoInitializingCheckingEvent());
    });
  });
}