import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:qurbani_app/models/user.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class OtpSent extends LoginState {
  final String phoneNo;
  final String verificationId;

  OtpSent({@required this.verificationId, @required this.phoneNo});

  @override
  List<Object> get props => [phoneNo, verificationId];
}

class OtpVerified extends LoginState {
  final UserDetail user;

  OtpVerified({@required this.user});

  @override
  List<Object> get props => [user];
}
