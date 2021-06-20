import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/bloc/auth/authentication_bloc.dart';
import 'package:qurbani_app/bloc/auth/authentication_event.dart';
import 'package:qurbani_app/bloc/auth/authentication_state.dart';
import 'package:qurbani_app/bloc/category/category_bloc.dart';
import 'package:qurbani_app/bloc/category/category_event.dart';
import 'package:qurbani_app/bloc/login/login_bloc.dart';
import 'package:qurbani_app/bloc/login/login_event.dart';
import 'package:qurbani_app/bloc/login/login_state.dart';
import 'package:qurbani_app/config/size.dart';
import 'package:qurbani_app/models/user.dart';
import 'package:qurbani_app/screens/home_screen.dart';
import 'package:qurbani_app/screens/otp_screen.dart';
import 'package:qurbani_app/screens/signup_screen.dart';
import 'package:qurbani_app/services/auth_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            final authBloc = BlocProvider.of<AuthenticationBloc>(context);
            if (state is AuthenticationNotAuthenticated) {
              return _AuthForm();
            }
            if (state is AuthenticationFailure) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    child: Text('Retry'),
                    onPressed: () {
                      authBloc.add(AppLoaded());
                    },
                  )
                ],
              ));
            }
            // return splash screen
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        ),
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
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  bool _autoValidate = false;

  String phoneNo;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    double deviceWidth = ScreenSize(context).deviceWidth;

    _onLoginButtonPressed() {
      if (_key.currentState.validate()) {
        _loginBloc.add(
          LoginInWithEmailButtonPressed(phoneNumber: phoneNo),
        );
      } else {
        setState(() {
          _autoValidate = true;
        });
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
                isSignup: false,
                userDetail: null,
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
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: IntlPhoneField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberController,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: InputBorder.none,
                          counterText: ''),
                      initialCountryCode: 'PK',
                      onChanged: (phone) {
                        phoneNo = phone.completeNumber;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed:
                        state is LoginLoading ? () {} : _onLoginButtonPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(16.0),
                    ),
                    child: Text('Login'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignupPage())),
                    child: Center(
                      child: Text(
                        'Don\'t have an account ? Sign up',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(
                            user: UserDetail(
                                name: 'moid',
                                phoneNo: '+923040532318',
                                address: 'afs'),
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'By Pass Login',
                      ),
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
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
