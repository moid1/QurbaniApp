import 'package:flutter/material.dart';

class ScreenSize {
  BuildContext context;

  ScreenSize(this.context) : assert(context != null);

  double get deviceWidth => MediaQuery.of(context).size.width;
  double get deviceHeight => MediaQuery.of(context).size.height;
}
