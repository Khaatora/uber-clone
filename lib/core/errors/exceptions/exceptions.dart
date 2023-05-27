import 'package:uber_own/core/global/localization.dart';

class ServerException implements Exception{
  final String message;
 const ServerException([this.message = EnglishLocalization.GenericFirebaseErrorMessage]);
}

class CacheException implements Exception{
  final String message;

  const CacheException(this.message);
}



class InternalException extends ServerException{

  const InternalException([super.message = EnglishLocalization.GenericFirebaseErrorMessage]);
}
class NoInternetException extends ServerException{


  const NoInternetException([super.message = EnglishLocalization.NoInternetErrorMessage]);
}
class InternetDisconnectedException extends ServerException{


  const InternetDisconnectedException([super.message = EnglishLocalization.NetworkDisconnectedWhileInUseErrorMessage]);
}
class InvalidCodeException extends ServerException{


  const InvalidCodeException([super.message = EnglishLocalization.InvalidCodeErrorMessage]);
}
class SignInFailedException extends ServerException{


  const SignInFailedException([super.message = EnglishLocalization.SignInErrorMessage]);
}
class InvalidCredentialsExceptions extends ServerException{


  const InvalidCredentialsExceptions([super.message = EnglishLocalization.InvalidCredentialsErrorMessage]);
}
class InvalidPhoneNumberException extends ServerException{


  const InvalidPhoneNumberException([super.message = EnglishLocalization.InvalidPhoneNumberErrorMessage]);
}
class GenericException extends ServerException{
  const GenericException([super.message = EnglishLocalization.GenericFirebaseErrorMessage]);
}