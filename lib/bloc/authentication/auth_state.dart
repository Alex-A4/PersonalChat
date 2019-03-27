import 'package:equatable/equatable.dart';

///Default class to describes authentication state
class AuthState extends Equatable {}

///This state indicates that app just started and is loading all helpful
/// data, so show some loading page
class AuthAppStartedState extends AuthState {
  @override
  String toString() => 'AuthAppStartedState';
}

///This state indicate that app is loaded and user not authenticated,
/// so show LogIn page
class AuthLogInState extends AuthState {
  @override
  String toString() => 'AuthLogInState';
}

///This state indicates that app is loaded and user is not registered in chat
/// system, so he must do that
class AuthSignInState extends AuthState {
  @override
  String toString() => 'AuthSignInState';
}

///This state indicates that app is loaded and user authenticated in chat system
/// so show Chat screen
class AuthAuthenticatedState extends AuthState {
  @override
  String toString() => 'AuthAuthenticatedState';
}
