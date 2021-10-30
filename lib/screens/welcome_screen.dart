import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(

      duration: Duration(seconds: 2),
      vsync: this);
    animation = ColorTween(begin: Colors.pinkAccent, end: Colors.white).animate(controller!);
    controller!.forward(from: 0);
    controller!.addListener(() {
      setState(() {

      });
      print(controller!.value);
      print('animation: ${animation!.value}');
    });


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(

                  animatedTexts: [
                 WavyAnimatedText('Flash Chat',
                   textStyle:
                 TextStyle(
                   fontSize: 45,
                   fontWeight: FontWeight.w900,
                   fontFamily: 'Canterbury',
                   color: Colors.black,
                 ),),

                  ],
                  isRepeatingAnimation: true,


                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
          RoundedButton(
            name: "Login",
            color: Colors.lightBlueAccent,
            callBack: (){

              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
            RoundedButton(
              name: "Register",
              color: Colors.blueAccent,
              callBack: (){
                Navigator.pushNamed(context, RegistrationScreen.id);

              },
            ),

          ],
        ),
      ),
    );
  }
}