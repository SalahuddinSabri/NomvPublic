// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomv/screen/Home/Home_screen.dart';
import 'package:nomv/screen/Leadership/Leadership.dart';
import 'package:nomv/screen/Listing_Module/Listing.dart';
import 'package:nomv/screen/Upcoming/Upcoming_Conference.dart';
import 'package:nomv/screen/aboutus/about_us.dart';
import 'package:nomv/screen/login/login_page.dart';
import 'package:nomv/screen/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MaterialApp(
      title: 'NOMV 2023',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey,),

      initialRoute: '/splash',

      routes: {
        '/splash': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/upcoming_conference': (context) => Upcoming_Conference(),
        '/about_us': (context) => AboutUs(),
        '/leadership': (context) => Leadership(),
        '/listing': (context) => Listing(),
        // '/drop_down': (context) => survey_screen(),
      },
    );
  }
}
