import 'package:flutter/material.dart';
import 'package:qurbani_app/bloc/auth/authentication_bloc.dart';
import 'package:qurbani_app/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurbani_app/bloc/login/login_event.dart';
import 'package:qurbani_app/bloc/login/login_state.dart';
import 'package:qurbani_app/models/user.dart';
import 'package:qurbani_app/screens/home_screen.dart';
import 'package:qurbani_app/services/auth_service.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNo;
  final String verificationID;
  final bool isSignup;
  final UserDetail userDetail;
  const OtpScreen({
    Key key,
    @required this.phoneNo,
    @required this.verificationID,
    @required this.isSignup,
    @required this.userDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final codeController0 = TextEditingController();
    final codeController1 = TextEditingController();
    final codeController2 = TextEditingController();
    final codeController3 = TextEditingController();
    final codeController4 = TextEditingController();
    final codeController5 = TextEditingController();

    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => LoginBloc(authBloc, authService),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is OtpVerified) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomePage(
                              user: state.user,
                            )));
              } else if (state is LoginLoading) {
                Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoginFailure) {
                _showError(state.error, context);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verification code has been sent to \n',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    direction: Axis.horizontal,
                    runSpacing: 20,
                    children: [
                      _otpTextField(context, true, codeController0),
                      _otpTextField(context, false, codeController1),
                      _otpTextField(context, false, codeController2),
                      _otpTextField(context, false, codeController3),
                      _otpTextField(context, false, codeController4),
                      _otpTextField(context, false, codeController5),
                    ],
                  ),
                ),
                verifiedButtonWidget(
                  codeController0,
                  codeController1,
                  codeController2,
                  codeController3,
                  codeController4,
                  codeController5,
                  context,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Did not get the code ? Resend Code'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String error, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }

  verifiedButtonWidget(
      TextEditingController codeController0,
      TextEditingController codeController1,
      TextEditingController codeController2,
      TextEditingController codeController3,
      TextEditingController codeController4,
      TextEditingController codeController5,
      context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () => {
            print('this is verifica $verificationID'),
            context.read<LoginBloc>().add(
                  VerifyOtp(
                      verificationId: verificationID,
                      code: codeController0.text +
                          codeController1.text +
                          codeController2.text +
                          codeController3.text +
                          codeController4.text +
                          codeController5.text,
                      isSignup: isSignup,
                      userDetail: userDetail),
                )
          },
          style: ElevatedButton.styleFrom(),
          child: Text(
            'Verify Code',
          ),
        );
      },
    );
  }

  Widget _otpTextField(BuildContext context, bool autoFocus,
      TextEditingController codeController) {
    return Container(
      height: MediaQuery.of(context).size.shortestSide * 0.13,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: TextField(
          autofocus: autoFocus,
          decoration:
              InputDecoration(border: InputBorder.none, counterText: ""),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(),
          maxLength: 1,
          controller: codeController,
          maxLines: 1,
          onChanged: (value) {
            if (value.length == 1) {
              //  FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}
