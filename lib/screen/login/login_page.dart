import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Listing_Module/Listing.dart';
import '../Resources_screen/resource_selector.dart';
import '../Utils/pdf_api.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/Home_screen.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Leadership/Leadership.dart';
import '../Resources_screen/Resource.dart';
import '../Resources_screen/Resource_infographics.dart';
import '../Upcoming/Upcoming_Conference.dart';
import '../Utils/const.dart';
import '../aboutus/about_us.dart';
import '../aboutus/who_we_are.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController nameController_login = new TextEditingController();
  TextEditingController emailController_login = new TextEditingController();


  final String loginUrl = base_url + 'login';

  void loginPostData(BuildContext context) async {
    SharedPreferences pref = await shared_pref;

    bool isOnline = await globals.hasNetwork();
    if (isOnline) {
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final msg = jsonEncode({
        "name": nameController_login.text,
        "email": emailController_login.text
      });

      final response = await post(
        Uri.parse(loginUrl),
        headers: headers,
        body: msg,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne_body = jsonDecode(response.body);

        if (resposne_body.containsKey('user')) {
          Map<String, dynamic> user = resposne_body['user'];

          print(" user id ${user['id']}");
          if (pref.containsKey("nomv_userid")) {
            pref.remove("nomv_userid");
          }

          pref.setString("nomv_userid", user['id'].toString());

          Navigator.pop(context);


          showLoaderDialog(context);
          // fetch_who_we_are(pref);
          fetch_all_data(pref);
        } else {
          // //dismiss dialog..!!
          Navigator.pop(context);

          dynamic asdd = convert.jsonDecode(response.body)['error'];

          final input = asdd['email'].toString();
          final removedBrackets = input.substring(1, input.length - 1);
          final parts = removedBrackets.split(', ');
          var joined = parts.map((part) => "$part").join(', ');

          Fluttertoast.showToast(
              msg: " ${joined.toString()}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff586BC6),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
      else {
        Fluttertoast.showToast(
            msg: "Failed to Login , Try Again..!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff586BC6),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    else {
      Fluttertoast.showToast(
          msg: "Internet Is Required..!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff586BC6),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Stack(
      children: <Widget>[
        WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff6fc372),
                      Color(0xff6fc372),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 150),
                      child: SizedBox(
                        child: Container(
                          alignment: Alignment.center, // use aligment
                          child: Image.asset('assets/images/splash_icon.png',
                              height: 120,
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Center(
                            child: Text(
                              'Let\u0027s get started',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),


                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 0),
                                    height: 22,
                                    width: 22,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(60, 5, 50, 0),
                          // padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),

                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                            ],
                            // inputFormatters: [NoSpaceFormatter()],
                            autocorrect: true,
                            enableSuggestions: true,
                            maxLength: 30,
                            keyboardType: TextInputType.name,
                            controller: nameController_login,

                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Username';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Name*',
                                counterText: '',
                                counterStyle: TextStyle(fontSize: 0),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,)),
                                hintStyle: TextStyle(color: Colors.white70)),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Karla',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 0),
                                    height: 22,
                                    width: 22,
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )),
                        ),

                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(60, 5, 50, 0),
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: TextFormField(
                            inputFormatters: [NoSpaceFormatter()],
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 100,
                            maxLines: 1,
                            controller: emailController_login,
                            validator: (value) {
                              // validateEmail(value);
                              if (value!.isEmpty) {
                                return 'Enter Email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                hintText: 'Email Address*',
                                counterText: '',
                                counterStyle: TextStyle(fontSize: 0),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )),

                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,)),
                                hintStyle: TextStyle(color: Colors.white70)),
                            style: TextStyle(

                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Karla',
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (nameController_login.text.isEmpty ||
                            emailController_login.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Credentials Required..!!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color(0xff586BC6),
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        } else {
                          // final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(nameController_login.text);
                          if (EmailValidator.validate(emailController_login
                              .text)) {
                            try {
                              FocusScope.of(context).unfocus();
                              showLoaderDialog(context);

                              loginPostData(context);
                            } on Exception catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Error" + e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff586BC6),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                          else {
                            Fluttertoast.showToast(
                                msg: "Valid email required",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xff586BC6),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      },

                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(35, 10, 35, 10),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xfffbf7ee),
                        ),

                        child: Text("Sign In",
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(112, 197, 115, 1))),),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        child: Center(child: Image.asset(
                          "assets/images/home_indicator.png", width: 70.0,),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }



  Future fetch_all_data(SharedPreferences pref) async {

    List<String> file_data_info = [];

    bool isOnline = await globals.hasNetwork();
    if (isOnline) {

      showCustom(context,true);
      final uri_val = await http.get(Uri.parse("${base_url}getalldata"),
        headers: <String, String>{"Content-Type": "application/json"},);

      if (uri_val.statusCode == 200) {

        if (pref.containsKey("json_all_data")) {
          pref.remove("json_all_data");
        }

        pref.setString("json_all_data", uri_val.body);

        if (pref.containsKey("json_all_data")) {

          //who we are
          if (pref.containsKey("json_who_we")) {
            pref.remove("json_who_we");
          }
          pref.setString("json_who_we", uri_val.body);
          if (pref.containsKey("json_who_we")) {

            //about us
            if (pref.containsKey("json_about_us")) {
              pref.remove("json_about_us");
            }
            pref.setString("json_about_us", uri_val.body);

            if (pref.containsKey("json_about_us")) {
              //leadership
              if (pref.containsKey("json_leadership")) {
                pref.remove("json_leadership");
              }
              pref.setString("json_leadership", uri_val.body);
              if (pref.containsKey("json_leadership")) {
                var my_data = json.decode(await rootBundle.loadString('assets/data/city.json'));
                var all_country_data = my_data["data"] as List;

                if (all_country_data != null && all_country_data.isNotEmpty) {
                  file_data_info = List.from(all_country_data);
                }
                if (file_data_info.isNotEmpty) {
                  if (pref.containsKey("pdf_downloaded_info")) {
                    pref.remove("pdf_downloaded_info");
                  }
                  pref.setStringList("pdf_downloaded_info", file_data_info);
                }

                if (pref.containsKey("pdf_downloaded_info")) {
                  //upcoming
                  if (pref.containsKey("json_upcoming_conference")) {
                    pref.remove("json_upcoming_conference");
                  }

                  pref.setString("json_upcoming_conference", uri_val.body);
                  if (pref.containsKey("json_upcoming_conference")) {

                    //resources
                    if (pref.containsKey("json_main_resource")) {
                      pref.remove("json_main_resource");
                    }
                    pref.setString("json_main_resource", uri_val.body);

                    if (pref.containsKey("json_main_resource")) {

                      //infographics
                      if (pref.containsKey("json_infographics")) {
                        pref.remove("json_infographics");
                      }
                      pref.setString("json_infographics", uri_val.body);

                      if (pref.containsKey("json_infographics")) {

                        //all_country
                        if (pref.containsKey("json_allcountry")) {
                          pref.remove("json_allcountry");
                        }
                        pref.setString("json_allcountry", uri_val.body);

                        if (pref.containsKey("json_allcountry")){

                          //resource category
                          //listings
                          if (pref.containsKey("json_listings_data")) {
                            pref.remove("json_listings_data");
                          }
                          pref.setString("json_listings_data", uri_val.body);

                          if (pref.containsKey("json_listings_data")) {

                            if (pref.containsKey("json_all_resources_data")) {
                              pref.remove("json_all_resources_data");
                            }
                            pref.setString("json_all_resources_data", uri_val.body);


                            if (pref.containsKey("json_all_resources_data")) {
                              print('all_data_is  ${'dumped'}');
                              showCustom(context, false);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      else {
        Navigator.pop(context);
        showCustom(context, false);

        Fluttertoast.showToast(
            msg: "Failed to fetch data. Try Again..!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff586BC6),
            textColor: Colors.white,
            fontSize: 16.0);
      }

    }
    else {
      Fluttertoast.showToast(
          msg: "Internet Is Required..!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff586BC6),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}


showLoaderDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return WillPopScope(
            onWillPop: () async => false,

            child: Center(
            child: Container(
              width: 40.0,
              height: 40.0,
              child: const CircularProgressIndicator(
                  backgroundColor: Color(0xffd7b563),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),),
          )
        );
      });
}

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value contains any spaces
    if (newValue.text.contains(' ')) {
      // If it does, return the old value
      return oldValue;
    }
    // Otherwise, return the new value
    return newValue;
  }
}

showCustom(BuildContext context, bool show_toast) {

  print('show_toast  $show_toast');
  if (show_toast){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fetching app data please wait..!!',
          textAlign: TextAlign.start, style: TextStyle(fontFamily: 'Lato',
              fontSize: 15.0,
              color: Colors.white,
            fontWeight: FontWeight.w500),), duration: Duration(seconds: 30), backgroundColor: Color.fromRGBO(195, 174, 121, 1),));
  } else {
    ScaffoldMessenger.of(context)..removeCurrentSnackBar();
  }
}

