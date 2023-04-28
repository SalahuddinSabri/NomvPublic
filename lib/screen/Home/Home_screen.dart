import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Leadership/Leadership.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Listing_Module/Listing.dart';
import '../Resources_screen/Resource.dart';
import '../Upcoming/Upcoming_Conference.dart';
import '../Utils/const.dart';
import '../aboutus/who_we_are.dart';
import 'home_data.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var session_count = "";
  var bookmark_count = "";
  var survey_count = "";

  @override
  void initState() {
    super.initState();
  }

  var gradient = [
    BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        Color(0xff4AB890),
        Color(0xff358C9C),
      ],
    )),
    BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        Color(0xffFCCF62),
        Color(0xffDAB353),
      ],
    )),
    BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        Color(0xff3EA9BD),
        Color(0xff586BC6),
      ],
    )),
    BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        Color(0xff8d379d),
        Color(0xff8c369b),
        Color(0xff923682),
      ],
    )),
    BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        Color(0xff85E189),
        Color(0xff70C5AB),
      ],
    )),
    BoxDecoration(
        gradient: LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [
        Color(0xff714cbf),
        Color(0xff774ec0),
        Color(0xff9959c6),
      ],
    )),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.transparent,
        ),
        WillPopScope(
          onWillPop: () async {
            exit(0);
          },

          child: Scaffold(
            appBar: new AppBar(
              centerTitle: true,
              elevation: 0,
              title: Image.asset('assets/images/splash_icon.png',
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitHeight),
              backgroundColor: Color.fromRGBO(52, 70, 153, 1),
              automaticallyImplyLeading: false,
            ),
            body: Container(
              color: Colors.transparent,
              // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              margin: EdgeInsets.only(top: 20),
              child: _buildList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: home_menu.length,
        itemBuilder: (BuildContext context, int index) {
          Home_Menu data = home_menu[index];
          return Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10),
            height: 100,
            child: Card(
              // margin: EdgeInsets.zero,
              elevation: 10.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7))),
              child: Container(
                decoration: gradient[index],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                          child: Home_Tile(data, bookmark_count, session_count,
                              survey_count, index, context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Widget Home_Tile(Home_Menu data, String book_count, String session_count,
    String survey_count, int index, BuildContext context) {
  return new ListTile(
    title: Container(
      margin: EdgeInsets.only(top: 5),
      child: new Text(data.title,
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Karla',
              color: Color.fromRGBO(255, 255, 255, 1),
              fontWeight: FontWeight.bold)),
    ),
    subtitle: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            data.subtitle,
            style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Karla',
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ],
      ),
    ),
    trailing: ClipRRect(
      child: Container(
        height: 30.0,
        width: 30.0,
        // child: Image.asset(
        //   data.home_image_path,
        //   height: 35.0,
        //   width: 35.0,
        // ),

        child: SvgPicture.asset(
          data.home_image_path,
          height: 35.0,
          width: 35.0,
          allowDrawingOutsideViewBox: true,
        ),
      ),
    ),
    onTap: () async {
      log("index_val" + index.toString());
      if (index == 0) {

        Navigator.push(context, MaterialPageRoute(builder: (context) => Who_We()),);

        // Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => Who_We()), (route) => false);

      } else if (index == 1) {

        Navigator.push(context, MaterialPageRoute(builder: (context) => Leadership()),);
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Leadership()), (route) => false);

      } else if (index == 2) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Upcoming_Conference()),);

        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Upcoming_Conference()), (route) => false);
      } else if (index == 3) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Resources_Screen()),);
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Resources_Screen()), (route) => false);
      } else if (index == 4) {
        SharedPreferences pref = await shared_pref;

        if (pref.containsKey("json_citystate")) {
          pref.remove("json_citystate");
        }

        if (pref.containsKey("filter_countryid")) {
          pref.remove("filter_countryid");
        }

        if (pref.containsKey("selected_statename")) {
          pref.remove("selected_statename");
        }

        if (pref.containsKey("selected_city")) {
          pref.remove("selected_city");
        }

        if (pref.containsKey("selected_resource")) {
          pref.remove("selected_resource");
        }

        //country name
        if (pref.containsKey("filter_countryname")) {
          pref.remove("filter_countryname");
        }
        //city
        if (pref.containsKey("filter_cityname")) {
         pref.remove("filter_cityname");
        }
        //state
        if (pref.containsKey("filter_statename")) {
          pref.remove("filter_statename");
        }
        //resource
        if (pref.containsKey("filter_resource")) {
          pref.remove("filter_resource");
        }

        if (pref.containsKey("json_city_by_state")) {
          pref.remove("json_city_by_state");
        }

        Navigator.push(context, MaterialPageRoute(builder: (context) => Listing()),);
      }

      else if (index == 5) {
        _launchURL();
      }
    },
  );
}

_launchURL() async {
  const url = 'https://www.nomv.org/speaker-requests/';
  if (await launch(url)) {
    await canLaunch(url);
  } else {
    throw 'Could not launch $url';
  }
}



