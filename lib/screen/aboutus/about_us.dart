import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/const.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class About_Us {
  final String description;

  About_Us(this.description);

  factory About_Us.fromJson(Map<String, dynamic> json) {
    return About_Us(json['description']);
  }
}


class _AboutUsState extends State<AboutUs> {
  late SharedPreferences pref;
  List<About_Us> about_us_we = [];
  bool should_load_about_us = false;

  @override
  void initState() {

    Timer(Duration(milliseconds: 500), () =>
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          print("called_delay   ${"d"}");
          pref = sp;
          fetch_aboutus(pref);
        }),
    );
    super.initState();
  }


  Future<List<About_Us>?> fetch_aboutus(SharedPreferences sharedPreferences) async {

    if (sharedPreferences.containsKey("json_about_us")) {
      dynamic about_us = convert.jsonDecode(sharedPreferences.getString("json_about_us").toString());
      var who = about_us["aboutus"] as List;
      if (who.isNotEmpty) {
        setState(() {
          about_us_we= who.map<About_Us>((json) => About_Us.fromJson(json)).toList();
          should_load_about_us = true;
        });
        print("all_we_are  ${about_us_we.length}   $should_load_about_us");
      }
      else {
        about_us_we.clear();
        return null;
      }
    } else {
      about_us_we.clear();
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    if (should_load_about_us) {
      return Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background_app.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            onWillPop: () async => true,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/toolbar_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                leading: Container(
                  margin: EdgeInsets.only(top: 2),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/back_menu.png',
                      height: 13,
                      width: 13,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                title: const Text('Learn More About Us',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.only(
                            top: 20, bottom: 10, right: 20, left: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(61, 163, 153, 0.15),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              bottom: 5,
                              right: 10,
                            ),
                            child: Html(
                              data: about_us_we[0].description,
                              onLinkTap: (String? url,
                                  RenderContext context,
                                  Map<String, String> attributes,
                                  dom.Element? element) {
                                launchURL(url!);
                              },

                              // Styling with CSS (not real CSS)
                              style: {
                                'h3': Style(
                                    fontFamily: 'Karla',
                                    fontSize: FontSize.xLarge,
                                    color: Color.fromRGBO(
                                        53, 140, 156, 1)),
                                'p': Style(
                                    color: Color.fromRGBO(
                                        102, 105, 114, 1),
                                    fontFamily: 'Lato',
                                    fontSize: FontSize.medium),
                                'li': Style(
                                    color: Color.fromRGBO(
                                        102, 105, 114, 1),
                                    fontFamily: 'Lato',
                                    fontSize: FontSize.medium)
                              },
                            ),
                          ),
                        ])))
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },

            child: Scaffold(
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/toolbar_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                leading: IconButton(
                  constraints: BoxConstraints(maxHeight: 36),
                  icon: Image.asset(
                    'assets/images/menu.png',
                    height: 15,
                    width: 15,
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                  },
                ),
                title: const Text('Who We Are',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),
              body: Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: const CircularProgressIndicator(
                      backgroundColor: Color(0xffd7b563),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),
                ),
              ),
            ),
          ),
        ],
      );
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
        /*return Center(
          child: Container(
              width: 40.0,
              height: 40.0,
            child: const CircularProgressIndicator(
                backgroundColor: Color(0xffd7b563),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),),
        );*/
      });
}


launchURL(String url) async {
  if (await launch(url)) {
    await canLaunch(url);
  } else {
    throw 'Could not launch $url';
  }
}
