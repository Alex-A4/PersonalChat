import 'package:equatable/equatable.dart';

///Default class to describes authentication events
class AuthEvent extends Equatable {}

///This event indicate that app had been started and need to load
/// all helpful data about user
class AppStartedEvent extends AuthEvent {
  @override
  String toString() => 'AppStartedEvent';
}

///This event indicates that app had been loaded and user must enter
/// password and phone number to log in system
class AuthLogInEvent extends AuthEvent {
  @override
  String toString() => 'AuthLogInEvent';
}

///This event indicates that app had been loaded and user want to create
/// new account
class AuthSignInEvent extends AuthEvent {
  @override
  String toString() => 'AuthSignInEvent';
}

///This event indicates that app had been loaded and user had been
/// authenticated in chat system
class AuthAuthenticatedEvent extends AuthEvent {
  @override
  String toString() => 'AuthAuthenticatedEvent';
}
