import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	
// This widget is the root of your application.
@override
Widget build(BuildContext context) {
	return MaterialApp(
		
	// Application name
	title: 'FitnestX',
		
	// Application theme data, you can set the
	// colors for the application as
	// you want
	theme: ThemeData(
		primarySwatch: Colors.blue,
	),
		
	// A widget which will be started on application startup
	home: AnimatedSplashScreen(
		splash: 'assets/SplashScreen/SplashScreenImage.png',
		nextScreen: MyHomePage(title: 'FitnestX'),
    splashIconSize: 250,
    duration: 2500,
		splashTransition: SplashTransition.fadeTransition,
    pageTransitionType: PageTransitionType.fade,
	),
	);
}
}

class MyHomePage extends StatelessWidget {
final String title;

const MyHomePage({required this.title});

@override
Widget build(BuildContext context) {
	return Scaffold(
	appBar: AppBar(
		
		// The title text which will be shown on the action bar
		title: Text(title),
	),
	body: Center(
		child: Text(
		'Test',
		),
	),
	);
}
}