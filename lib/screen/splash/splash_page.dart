import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomv/screen/Home/Home_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/const.dart';
import '../login/login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();



    SharedPreferences.getInstance().then((SharedPreferences sp) async {

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print('all_data      $appName   $packageName   $version   $buildNumber');
      _askCameraPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage('assets/images/splash_update.jpg'),
              fit: BoxFit.fill
          ),
        ));

   /* return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff36489C),

      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container( // Your Image
              height: 220,
              width: 220,
              child: Image.asset(
                'assets/images/updated_centersplash.png',
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            child: Container( // Your Button
              child: Text(
                "Version 2.0 ( Build 2.2 )",
                style: TextStyle(
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                maxLines: 1,   // TRY THIS
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            child: Container( // Your Button
              height: 30,
              width: 100,
              child: Image.asset("assets/images/home_indicator.png",),
            ),
          )
        ],
      ),
    );*/
  }


  Future<void> _askCameraPermission() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      //above android 10
      if (androidInfo.version.sdkInt > 29) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.manageExternalStorage,
        ].request();

        if (statuses[Permission.manageExternalStorage]!.isGranted) {
          Timer(Duration(seconds: 2), () => move_to_next());
        } else {
          exit(0);
        }
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();

        if (statuses[Permission.storage]!.isGranted) {
          Timer(Duration(seconds: 2), () => move_to_next());
        } else {
          exit(0);
        }
      }
    } else {
      Timer(Duration(seconds: 2), () => move_to_next());
    }
  }

  move_to_next() async {
    SharedPreferences pref = await shared_pref;
    if (pref.containsKey("nomv_userid")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
  }
}
