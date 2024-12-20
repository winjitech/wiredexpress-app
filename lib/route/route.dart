import 'package:wired_express/view/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String splashScreen = 'splash_screen';

Route<dynamic> controller(RouteSettings settings){
  switch(settings.name){
    case splashScreen:
      return MaterialPageRoute(builder: (context)=>SplashScreen());

    default:
      throw('This name is not exist');
  }
}