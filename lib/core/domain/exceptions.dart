
enum DBExceptionType{
  PLATFORM,
  NORMAL
}

class DBException implements Exception{
  final DBExceptionType type;

  DBException({
    required this.type
  });
}

enum ServerExceptionType{
  LOGIN,
  REFRESH_ACCESS_TOKEN,
  UNHAUTORAIZED,
  NORMAL
}

class ServerException implements Exception{
  final String message;
  final ServerExceptionType type;

  ServerException({
    this.message = '',
    required this.type
  });
}