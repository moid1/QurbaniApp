import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/bloc/auth/authentication_bloc.dart';
import 'package:qurbani_app/bloc/auth/authentication_event.dart';
import 'package:qurbani_app/models/user.dart';

class HomePage extends StatelessWidget {
  final UserDetail user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Welcome, ${user.name}',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Logout'),
                onPressed: () {
                  authBloc.add(UserLoggedOut());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
