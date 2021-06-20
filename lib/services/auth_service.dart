import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurbani_app/exception/authentication_exception.dart';
import 'package:qurbani_app/models/user.dart';

abstract class AuthenticationService {
  Future<UserDetail> getCurrentUser();
  Future<String> signInWithPhoneNumber(String phoneNo);
  Future<void> signUpWithPhoneNumber(UserDetail userDetail);

  Future<void> signOut();
}

class FirebaseRepository extends AuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential userCredential;
  String verificationCode;
  String verificationId;

  @override
  Future<UserDetail> getCurrentUser() async {
    return null; // return null for now
  }

  @override
  Future<String> signInWithPhoneNumber(String phoneNo) async {
    print('this is ' + phoneNo);
    var completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('Verification Completed');
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        throw AuthenticationException(message: e.message);
      },
      codeSent: (String verificationId, int resentToken) {
        print('Code Sent');
        this.verificationId = verificationId;
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return completer.future;
  }

  Future<void> verifyOTP(verificationId, smsCode) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential?.user != null) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Future<void> signUpWithPhoneNumber(UserDetail userDetail) async {
    var completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      phoneNumber: userDetail.phoneNo,
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('Verification Completed');
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        throw AuthenticationException(message: e.message);
      },
      codeSent: (String verificationId, int resentToken) {
        print('Code Sent');
        this.verificationId = verificationId;
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return completer.future;
  }

  @override
  Future<void> signOut() {
    return null;
  }
}
