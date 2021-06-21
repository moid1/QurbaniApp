import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurbani_app/bloc/auth/authentication_bloc.dart';
import 'package:qurbani_app/exception/authentication_exception.dart';
import 'package:qurbani_app/models/user.dart';
import 'package:qurbani_app/services/auth_service.dart';
import 'login_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // ignore: unused_field
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;
  final _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  LoginBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event);
    } else if (event is VerifyOtp) {
      yield* _mapVerifiyOtpToState(event);
    } else if (event is SignUpButtonPressed) {
      yield* _mapSignupToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginInWithEmailButtonPressed event) async* {
    yield LoginLoading();
    try {
      final userAlreadyExists = await users.doc(event.phoneNumber).get();
      if (userAlreadyExists.exists) {
        String verificationID = await _authenticationService
            .signInWithPhoneNumber(event.phoneNumber);
        print('this is veri $verificationID');
        if (verificationID == null)
          yield LoginFailure(error: "FirebaseAuth SMS not working");
        else
          yield OtpSent(
              verificationId: verificationID, phoneNo: event.phoneNumber);
      } else {
        yield LoginFailure(error: "User Not Found");
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }

  Stream<LoginState> _mapVerifiyOtpToState(VerifyOtp event) async* {
    print('this is code ${event.code}');
    yield LoginLoading();
    if (event.code.isEmpty) {
      yield LoginFailure(error: 'Please Enter Valid OTP');
    } else if (event.verificationId == null) {
      yield LoginFailure(error: 'Verification Id not found');
    } else {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.code);
      print(phoneAuthCredential.verificationId);

      try {
        final authCredentials =
            await _auth.signInWithCredential(phoneAuthCredential);
        if (event.isSignup) {
          users
              .doc(event.userDetail.phoneNo)
              .set(event.userDetail.toJson())
              .then((value) => print('User addess'))
              .catchError((onError) => print('this is error $onError'));
          yield OtpVerified(user: event.userDetail);
        } else {
          final userSnapShot =
              await users.doc(authCredentials.user.phoneNumber).get();
          yield OtpVerified(user: UserDetail.fromSnapshot(userSnapShot));
        }
      } on FirebaseAuthException catch (e) {
        yield LoginFailure(error: e.message ?? 'An unknown error occured');
      }
    }
  }

  Stream<LoginState> _mapSignupToState(SignUpButtonPressed event) async* {
    yield LoginLoading();
    try {
      final userAlreadyExists = await users.doc(event.userDetail.phoneNo).get();
      if (userAlreadyExists.exists) {
        yield LoginFailure(error: 'User Already Available');
      } else {
        String verificationID = await _authenticationService
            .signInWithPhoneNumber(event.userDetail.phoneNo);
        print('this is veri $verificationID');

        if (verificationID == null)
          yield LoginFailure(error: 'Service Unavailable Right Now');
        else
          yield OtpSent(
              verificationId: verificationID,
              phoneNo: event.userDetail.phoneNo);
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }
}
