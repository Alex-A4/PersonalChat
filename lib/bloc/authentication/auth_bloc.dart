import 'package:bloc/bloc.dart';
import 'package:personal_chat/repositories/chat_repository.dart';
import 'package:personal_chat/repositories/user_repository.dart';
import 'auth.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthenticationBloc(this.userRepository);

  @override
  AuthState get initialState => AuthAppStartedState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStartedEvent) {
      await userRepository.restoreFromCache();
      await ChatRepository.buildInstance();

      yield userRepository.isUserExist()
          ? AuthAuthenticatedState
          : AuthLogInState();
    }

    if (event is AuthLogInEvent) yield AuthLogInState();

    if (event is AuthSignInEvent) yield AuthSignInState();

    if (event is AuthAuthenticatedEvent) yield AuthAuthenticatedState();
  }
}
