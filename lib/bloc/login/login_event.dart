import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:qurbani_app/models/user.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginInWithEmailButtonPressed extends LoginEvent {
  final String phoneNumber;

  LoginInWithEmailButtonPressed({@required this.phoneNumber});

  @override
  List<Object> get props => [
        phoneNumber,
      ];
}

class VerifyOtp extends LoginEvent {
  final String code;
  final String verificationId;
  final bool isSignup;
  final UserDetail userDetail;

  VerifyOtp({
    @required this.verificationId,
    @required this.code,
    @required this.isSignup,
    @required this.userDetail,
  });

  @override
  List<Object> get props => [verificationId, code, isSignup, userDetail];
}

class SignUpButtonPressed extends LoginEvent {
  final UserDetail userDetail;

  SignUpButtonPressed({@required this.userDetail});

  @override
  List<Object> get props => [userDetail];
}
