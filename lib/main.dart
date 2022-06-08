import 'package:flutter/material.dart';
import 'package:flutter_ds_bfi/flutter_ds_bfi.dart';
import 'package:oktoast/oktoast.dart';
import 'package:task_rahmanda_one/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.top,
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: DSColor.primaryBlue,
            highlightColor: Colors.transparent,
            brightness: Brightness.light,
            splashColor: Colors.transparent,
            appBarTheme: const AppBarTheme(brightness: Brightness.light)),
        darkTheme: ThemeData(
            primaryColor: DSColor.primaryBlue,
            highlightColor: Colors.transparent,
            brightness: Brightness.dark,
            splashColor: Colors.transparent,
            appBarTheme: const AppBarTheme(brightness: Brightness.dark)),
        onGenerateRoute: Routers.generateRoute,
        initialRoute: '/splash-screen',
      ),
    );
  }
}


