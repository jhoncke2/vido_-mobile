import 'package:dartz/dartz.dart';
import 'package:vido/core/domain/exceptions.dart';
import 'package:vido/core/domain/failures.dart';
import 'package:vido/core/external/user_extra_info_getter.dart';
import 'package:vido/features/init/presentation/use_cases/there_is_authentication.dart';

class ThereIsAuthenticationImpl implements ThereIsAuthentication{
  final UserExtraInfoGetter accessTokenGetter;
  const ThereIsAuthenticationImpl({
    required this.accessTokenGetter
  });

  @override
  Future<Either<Failure, bool>> call()async{
    try{
      await accessTokenGetter.getAccessToken();
      return const Right(true);
    } on StorageException catch(exception){
      if(exception.type == StorageExceptionType.EMPTYDATA){
        return const Right(false);
      }else{
        return Left(Failure(exception: exception, message: exception.message??''));
      }
    } on Exception{
      return const Left(Failure(exception: AppException(''), message: ''));
    }
  }
}