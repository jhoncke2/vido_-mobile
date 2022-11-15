import 'package:equatable/equatable.dart';

class AppException extends Equatable{
  final String? message;
  const AppException(this.message);
  @override
  List<Object?> get props => [message];
}

enum DBExceptionType{
  PLATFORM,
  NORMAL
}

enum StorageExceptionType{
  EMPTYDATA,
  NORMAL
}

class StorageException extends AppException{
  final StorageExceptionType type;
  const StorageException({
    required String message, 
    required this.type
  }): super(
    message
  );
  @override
  List<Object?> get props => [message, type];
}

class DBException extends AppException{
  final DBExceptionType type;
  const DBException({
    required this.type,
    String message = ''
  }): super(message);
  @override
  List<Object?> get props => [...super.props, type];
}

enum ServerExceptionType{
  LOGIN,
  REFRESH_ACCESS_TOKEN,
  UNHAUTORAIZED,
  NORMAL
}

class ServerException extends AppException{
  final ServerExceptionType type;
  const ServerException({
    required this.type,
    String message = ''
  }): super(message);
  @override
  List<Object?> get props => [...super.props, type];
}