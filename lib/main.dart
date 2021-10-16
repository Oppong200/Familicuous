import 'package:familicious/views/home/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      title: 'Familicious',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(249, 251, 252, 1),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            color: Colors.black,
          ),
        ),
       
      ),

      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey.withOpacity(.5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
       textTheme: const TextTheme(
         bodyText1: TextStyle(color: Colors.white,
         ),
         bodyText2: TextStyle(color: Colors.white,),),
      ),
      themeMode: ThemeMode.dark,
      home: const HomeView(),
    );
  }
}
