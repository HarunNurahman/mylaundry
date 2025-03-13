import 'package:flutter/material.dart';
import 'package:mylaundry/screen/auth/register_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {'/register': (context) => RegisterScreen()};
  }
}
