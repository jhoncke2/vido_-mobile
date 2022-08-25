import 'package:vido/core/domain/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:vido/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:vido/features/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:vido/features/authentication/domain/failures/failures.dart';
import 'package:vido/features/authentication/domain/entities/user.dart';
import 'package:vido/features/authentication/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository{
  static const nonRecognizedErrorMessage = 'Ha ocurrido un error inesperado';
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;
  AuthenticationRepositoryImpl({
    required this.remoteDataSource, 
    required this.localDataSource
  });

  @override
  Future<Either<AuthenticationFailure, void>> login(User user)async{
    return await _manageFunctionExceptions<void>(()async{
      final accessToken = await remoteDataSource.login(user);
      final userId = await remoteDataSource.getUserId(accessToken);
      final newUser = User(id: userId, email: user.email, password: user.password);
      await localDataSource.setUser(newUser);
      await localDataSource.setAccessToken(accessToken);
      return const Right(null);
    });
  }

  @override
  Future<Either<AuthenticationFailure, void>> logout()async{
    return await _manageFunctionExceptions<void>(()async{
      await localDataSource.resetApp();
      return const Right(null);
    });
  }

  @override
  Future<Either<AuthenticationFailure, void>> reLogin()async{
    return await _manageFunctionExceptions<void>(()async{
      final user = await localDataSource.getUser();
      final accessToken = await remoteDataSource.login(user);
      final id = await remoteDataSource.getUserId(accessToken);
      final newUser = User(id: id, email: user.email, password: user.password);
      await localDataSource.setUser(newUser);
      await localDataSource.setAccessToken(accessToken);
      return const Right(null);
    });
  }

  Future<Either<AuthenticationFailure, T>> _manageFunctionExceptions<T>(
    Future<Either<AuthenticationFailure, T>> Function() function
  )async{
    try{
      return await function();
    }on AppException catch(exception){
      return Left(AuthenticationFailure(
        message: exception.message??nonRecognizedErrorMessage,
        exception: exception
      ));
    }catch(exception, stackTrace){
      print(stackTrace);
      return const Left(AuthenticationFailure(
        message: nonRecognizedErrorMessage,
        exception: AppException(nonRecognizedErrorMessage)
      ));
    }
  }
}