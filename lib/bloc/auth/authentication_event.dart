import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:qurbani_app/models/user.dart';


abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends AuthenticationEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent {
  final UserDetail user;

  UserLoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

// Fired when the user has logged out
class UserLoggedOut extends AuthenticationEvent {}