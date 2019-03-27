import 'package:bloc/bloc.dart';
import 'auth.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthAppStartedState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartedEvent) {
      //TODO: load user data
      yield AuthLogInState();
    }

    if (event is AuthLogInEvent) yield AuthLogInState();

    if (event is AuthSignInEvent) yield AuthSignInState();

    if (event is AuthAuthenticatedEvent) yield AuthAuthenticatedState();
  }
}
