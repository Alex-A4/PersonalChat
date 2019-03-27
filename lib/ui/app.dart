import 'package:flutter/material.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/repositories/user_repository.dart';
import 'package:personal_chat/ui/auth_ui/log_in.dart';
import 'package:personal_chat/ui/auth_ui/sign_in.dart';
import 'package:personal_chat/ui/chat_ui/main_screen.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = AuthenticationBloc(UserRepository());
    bloc.dispatch(AppStartedEvent());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: bloc,
      child: BlocBuilder<AuthEvent, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is AuthAppStartedState)
            return Container(color: Colors.white);

          if (state is AuthLogInState) return LogInScreen();

          if (state is AuthSignInState) return SignInScreen();

          if (state is AuthAuthenticatedState) return MainScreen();
        },
      ),
    );
  }
}