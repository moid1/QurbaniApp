import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/screens/home_screen.dart';
import 'package:qurbani_app/screens/login_screen.dart';
import 'package:qurbani_app/services/auth_service.dart';

import 'bloc/auth/authentication_bloc.dart';
import 'bloc/auth/authentication_event.dart';
import 'bloc/auth/authentication_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    RepositoryProvider<AuthenticationService>(
      create: (context) {
        return FirebaseRepository();
      },
      child: BlocProvider<AuthenticationBloc>(
        create: (context) {
          final authService =
              RepositoryProvider.of<AuthenticationService>(context);
          return AuthenticationBloc(authService)..add(AppLoaded());
        },
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qurbani App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return HomePage(
              user: state.user,
            );
          }
          return LoginPage();
        },
      ),
    );
  }
}
