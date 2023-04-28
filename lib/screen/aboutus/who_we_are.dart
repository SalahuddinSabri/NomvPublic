import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Home/Home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Leadership/Leadership.dart';
import '../Utils/const.dart';
import 'about_us.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Who_We extends StatefulWidget {
  @override
  _Who_WeStateState createState() => _Who_WeStateState();
}

class Who_We_Are {
  final String description;

  Who_We_Are(this.description);

  factory Who_We_Are.fromJson(Map<String, dynamic> json) {
    return Who_We_Are(json['description']);
  }
}

class _Who_WeStateState extends State<Who_We> {
  var heading_value = "";
  var desc_value = "";
  late SharedPreferences pref;
  List<Who_We_Are> who_we_are = [];
  bool should_load_who_we = false;

  @override
  void initState() {

    Timer(Duration(milliseconds: 500), () =>
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          print("called_delay   ${"d"}");
          pref = sp;
          fetch_who_we_are(pref);
        }),
    );
    super.initState();
  }

  Future<List<Who_We_Are>?> fetch_who_we_are(SharedPreferences sharedPreferences) async {

    if (sharedPreferences.containsKey("json_who_we")) {
      dynamic who_are = convert.jsonDecode(sharedPreferences.getString("json_who_we").toString());
      print("who_dataa    $who_are");

      var who = who_are["whoweare"] as List;
      print("who_dataa2    ${who.toString()}");

      if (who.isNotEmpty) {
        setState(() {
          who_we_are= who.map<Who_We_Are>((json) => Who_We_Are.fromJson(json)).toList();
          should_load_who_we = true;
        });
        print("all_we_are  ${who_we_are.length}   $should_load_who_we");
      }
      else {
        who_we_are.clear();
        return null;
      }
    }
    else {
      who_we_are.clear();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    print("called_delay22   $should_load_who_we");

    if (should_load_who_we) {
      return Stack(
        children: <Widget>[
          WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
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
              body: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(61, 163, 153, 0.15),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: <Widget>[
                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        bottom: 20,
                                        right: 15,
                                        top: 5),

                                    child: Html(
                                      data: who_we_are[0].description,
                                      shrinkWrap: true,
                                      style: {
                                        'p': Style(
                                            fontFamily: 'Lato',
                                            color: Color.fromRGBO(
                                                102, 105, 114, 1),
                                            fontSize: FontSize.medium),
                                        'li': Style(
                                            color: Color.fromRGBO(
                                                102, 105, 114, 1),
                                            fontFamily: 'Lato',
                                            fontSize: FontSize.medium)
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AboutUs()),
                                      );
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 15),
                                        child: Center(
                                            child: Image.asset(
                                          "assets/images/learn_more.png",
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ))),
                                  ),
                                ]),
                          ),
                        ]))),
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

      /*return Center(
        child: Container(
          width: 40.0,
          height: 40.0,
          child: const CircularProgressIndicator(
              backgroundColor: Color(0xffd7b563),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xff714CBF))),
        ),
      );*/
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

}
