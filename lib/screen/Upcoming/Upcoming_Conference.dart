import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Home/Home_screen.dart';
import '../Home/home_data.dart';
import '../Utils/const.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Upcoming_Conference extends StatefulWidget {
  @override
  _Upcoming_ConferenceState createState() => _Upcoming_ConferenceState();
}

class Upcoming_Data {
  final String conf_date;
  final String conf_name,
      conf_location,
      conf_description,
      created_at,
      updated_at;

  Upcoming_Data(this.conf_date, this.conf_name, this.conf_location,
      this.conf_description, this.created_at, this.updated_at);

  factory Upcoming_Data.fromJson(Map<String, dynamic> json) {
    return Upcoming_Data(
        json['conf_date'],
        json['conf_name'],
        json['conf_location'],
        json['conf_description'],
        json['created_at'],
        json['updated_at']);
  }
}

class _Upcoming_ConferenceState extends State<Upcoming_Conference> with TickerProviderStateMixin {
  late TabController controller;

  List all_session = [];
  List<Upcoming_Data> upcoming_data = [];
  bool should_load_upcoming_data = false;
  late SharedPreferences pref;

  @override
  void initState() {

    Timer(Duration(milliseconds: 500), () =>
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          pref = sp;
          upcoming_fetchdata(pref);
        }),
    );
    super.initState();
  }

  Future<List<Upcoming_Data>?> upcoming_fetchdata(SharedPreferences sharedPreferences) async {

    if (sharedPreferences.containsKey("json_upcoming_conference")) {
      dynamic about_us = convert.jsonDecode(sharedPreferences.getString("json_upcoming_conference").toString());
      var who = about_us["upcoming_conf"] as List;
      if (who.isNotEmpty) {
        setState(() {
          upcoming_data = who.map<Upcoming_Data>((json) => Upcoming_Data.fromJson(json)).toList();
          should_load_upcoming_data = true;
        });
      }
      else {
        upcoming_data.clear();
        return null;
      }
    }
    else {
      upcoming_data.clear();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (should_load_upcoming_data) {
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
                      image: AssetImage('assets/images/upcoming_session.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                leading: IconButton(
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
                title: const Text('Upcoming Conferences',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),
              body: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: ListView.builder(
                      itemCount: upcoming_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 120,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                    bottomRight: Radius.circular(7),
                                    bottomLeft: Radius.circular(7))),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.transparent),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                  colors: [
                                    Color.fromRGBO(62, 169, 189, 0.15),
                                    Color.fromRGBO(88, 107, 198, 0.1),
                                    // Color.fromRGBO(130, 52, 243, 1),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: Container(

                                        child: new ListTile(
                                          title: Container(
                                            margin: EdgeInsets.only(top: 15),
                                            child: Container(
                                              width: 200,
                                              child: Text(
                                                upcoming_data[index].conf_description.isEmpty ? "To be available soon" : upcoming_data[index]
                                                    .conf_description
                                                    .length >
                                                    60
                                                    ? upcoming_data[index]
                                                    .conf_description
                                                    .substring(
                                                    0, 60) +
                                                    '...'
                                                    : upcoming_data[index]
                                                    .conf_description,
                                                maxLines: 1,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Karla',
                                                  color: Color(0xff36489C),
                                                  fontWeight: FontWeight.w700,
                                                  // decoration: TextDecoration.underline, decorationThickness: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          subtitle: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        upcoming_data[index]
                                                            .conf_location
                                                            .isEmpty
                                                            ? "To be available soon"
                                                            : upcoming_data[index]
                                                            .conf_location,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Color(
                                                              0xff1E2A60),
                                                          fontFamily:
                                                          'Karla',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Row(children: [
                                                  Container(
                                                    padding:
                                                    EdgeInsets.zero,
                                                    child: Image.asset(
                                                      "assets/images/upcoming_sessiondate.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    upcoming_data[index]
                                                        .conf_date
                                                        .isEmpty
                                                        ? "To be available soon"
                                                        : upcoming_data[index]
                                                        .conf_date,
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color:
                                                      Color(0xff242124),
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontFamily: 'Karla',
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ),
                                          trailing: Container(
                                            margin:
                                            EdgeInsets.only(top: 25),
                                            child: ClipRRect(
                                              child: Container(
                                                height: 20.0,
                                                width: 20.0,
                                                child: Image.asset(
                                                  "assets/images/upcoming_icon.png",
                                                  height: 20.0,
                                                  width: 20.0,
                                                ),
                                              ),
                                            ),
                                          ),

                                          onTap: () async {
                                            launchURL(upcoming_data[index].conf_name);
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      );
    }
    else {
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
                      image: AssetImage('assets/images/upcoming_session.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                leading: IconButton(
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
                title: const Text('Upcoming Conferences',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),
              body: Align(
                alignment: Alignment.center,
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
        return Center(
          child: Container(
            width: 40.0,
            height: 40.0,
            child: const CircularProgressIndicator(
                backgroundColor: Color(0xffd7b563),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),
          ),
        );
      });
}

launchURL(String url) async {
  if (await launch(url)) {
    await canLaunch(url);
  } else {
    throw 'Could not launch $url';
  }
}
