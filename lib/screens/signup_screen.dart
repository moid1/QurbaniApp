import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/bloc/auth/authentication_bloc.dart';
import 'package:qurbani_app/bloc/auth/authentication_event.dart';
import 'package:qurbani_app/bloc/auth/authentication_state.dart';
import 'package:qurbani_app/bloc/login/login_bloc.dart';
import 'package:qurbani_app/bloc/login/login_event.dart';
import 'package:qurbani_app/bloc/login/login_state.dart';
import 'package:qurbani_app/config/size.dart';
import 'package:qurbani_app/models/user.dart';
import 'package:qurbani_app/services/auth_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'otp_screen.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: _AuthForm(),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignUpForm(),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  __SignUpFormState createState() => __SignUpFormState();
}

class __SignUpFormState extends State<_SignUpForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  String phoneNumber;

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onSignupButtonPressed() {
      if (_key.currentState.validate()) {
        _loginBloc.add(
          SignUpButtonPressed(
            userDetail: UserDetail(
                name: nameController.text,
                address: addressController.text,
                phoneNo: phoneNumber),
          ),
        );
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        } else if (state is OtpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                phoneNo: state.phoneNo,
                verificationID: state.verificationId,
                isSignup: true,
                userDetail: UserDetail(
                    name: nameController.text,
                    address: addressController.text,
                    phoneNo: phoneNumber),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      isDense: true,
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    controller: nameController,
                    validator: (value) {
                      if (value == null) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address',
                      filled: true,
                      isDense: true,
                    ),
                    keyboardType: TextInputType.text,
                    controller: addressController,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    child: IntlPhoneField(
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                          counterText: ''),
                      initialCountryCode: 'PK',
                      onChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                        print(phone.completeNumber);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                        state is LoginLoading ? () {} : _onSignupButtonPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(16.0),
                    ),
                    child: Text('Signup'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Text(
                      'Already Have Account ? Login',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }
}
