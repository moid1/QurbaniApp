import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurbani_app/exception/authentication_exception.dart';
import 'package:qurbani_app/models/category.dart';
import 'package:qurbani_app/models/products.dart';
import 'package:qurbani_app/models/user.dart';

abstract class AuthenticationService {
  //Auth Functions
  Future<UserDetail> getCurrentUser();
  Future<String> signInWithPhoneNumber(String phoneNo);
  Future<void> signUpWithPhoneNumber(UserDetail userDetail);
  Future<void> signOut();
  /////

  Future<List<CategoryModel>> getCurrentCategories();
  Future<List<ProductModel>> getProducts(String categoryId);
}

class FirebaseRepository extends AuthenticationService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  UserCredential userCredential;
  String verificationCode;
  String verificationId;

  @override
  Future<UserDetail> getCurrentUser() async {
    return null;
    // return UserDetail.fromSnapshot(
    //     await usersCollection.doc(_auth.currentUser.phoneNumber).get());
  }

  @override
  Future<String> signInWithPhoneNumber(String phoneNo) async {
    print('this is ' + phoneNo);
    var completer = Completer<String>();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('Verification Completed');
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(null);
          throw AuthenticationException(message: e.message ?? 'Unknown Error');
        },
        codeSent: (String verificationId, int resentToken) {
          print('Code Sent');
          this.verificationId = verificationId;
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Again Code Sent');
          this.verificationId = verificationId;
          completer.complete(verificationId);
        },
      );
    } catch (error) {
      completer.complete(null);
    }

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

  @override
  Future<List<CategoryModel>> getCurrentCategories() async {
    QuerySnapshot querySnapshot = await categoryCollection.get();
    var categories = querySnapshot.docs.map((e) {
      return CategoryModel(
          id: e.id,
          name: e.get('name'),
          createdAt: e.get('created_at'),
          image: e.get('image'));
    }).toList();

    return categories;
  }

  @override
  Future<List<ProductModel>> getProducts(String categoryId) async {
    QuerySnapshot querySnapshot = await productsCollection
        .where('category_id', isEqualTo: categoryId)
        .get();

    var products = querySnapshot.docs.map((e) {
      return ProductModel.fromSnapshot(e);
    }).toList();

    print(products.length);

    return products;
  }
}
