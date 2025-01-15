import 'package:flutter/material.dart';
import 'package:quotes_generator/home.dart';
import 'package:quotes_generator/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      theme: ThemeData(
       // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
 
      
      home: SplashScreen(),
      routes: {
        "/splash" : (context) => SplashScreen(),
        "/home" : (context) => HomeScreen(),
      },
    );
  }
}

