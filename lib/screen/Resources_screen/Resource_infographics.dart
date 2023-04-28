import 'dart:async';

import 'package:analyzer/file_system/file_system.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Home/Home_screen.dart';
import 'package:nomv/screen/Resources_screen/Resource.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import '../Utils/const.dart';
import '../Utils/pdf_api.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Utils/pdf_viewer_page.dart';

class Resources_infographics extends StatefulWidget {
  String heading_name;

  Resources_infographics({Key? key, required this.heading_name})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new Resources_infographics_State();
  }
}

class Resources_info {
  final String resource_name;
  final String resource_url;

  Resources_info(this.resource_name, this.resource_url);

  factory Resources_info.fromJson(Map<String, dynamic> json) {
    return Resources_info(json['resource_name'], json['resource_url']);
  }
}

class Resources_infographics_State extends State<Resources_infographics> {

  List<Resources_info> resuorce_info_data = [];
  bool should_load_resuorce_info = false;
  late SharedPreferences pref;

  @override
  void initState() {
    Timer(Duration(milliseconds: 500), () =>
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          pref = sp;
          infographics_fetchdata(pref);
        }));

    super.initState();
  }

  Future<List<Resources_info>?> infographics_fetchdata(SharedPreferences sharedPreferences) async {

    if (sharedPreferences.containsKey("json_infographics")) {
      dynamic asdd = convert.jsonDecode(sharedPreferences.getString("json_infographics")!);
      var Resources_info_array = asdd["infographics"] as List;
      if (Resources_info_array.isNotEmpty) {
        setState(() {
          resuorce_info_data = Resources_info_array.map<Resources_info>((json) => Resources_info.fromJson(json)).toList();
          should_load_resuorce_info = true;
        });
      } else {
        resuorce_info_data.clear();
        return null;
      }
    }
    else {
      resuorce_info_data.clear();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (should_load_resuorce_info) {
      return Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background_app.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => Resources_Screen()),
              //     (route) => false);
              return true;
            },
            child: Scaffold(
              // backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/resource_back.png'),
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
                title: Text(
                    widget.heading_name.isEmpty
                        ? "To be available soon"
                        : widget.heading_name,
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
                      itemCount: resuorce_info_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // margin: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
                          height: 90,
                          child: Card(
                            color: Color(0xfff3eaf2),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/resource_background.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                        child: ResourcesListTile(
                                            resuorce_info_data[index],
                                            context)),
                                  ),
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
    } else {
      return Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background_app.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => Resources_Screen()),
              //     (route) => false);
              return true;
            },
            child: Scaffold(
              // backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/resource_back.png'),
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
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(
                      //         builder: (context) => Resources_Screen()),
                      //     (route) => false);
                    },
                  ),
                ),
                title: Text(
                    widget.heading_name.isEmpty
                        ? "To be available soon"
                        : widget.heading_name,
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

class ResourcesListTile extends ListTile {
  ResourcesListTile(data, BuildContext context)
      : super(
    leading: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 250,
              child: Text(
                data.resource_name.isEmpty
                    ? "To be available soon"
                    : data.resource_name,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(140, 54, 156, 1),
                  fontFamily: 'Karla',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    dense: true,
    onTap: () async {

      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt > 29) {
          if (await Permission.manageExternalStorage.isGranted) {
            openPDF(context, data.resource_url);
          }
        } else {
          if (await Permission.storage.isGranted) {
            openPDF(context, data.resource_url);
          }
        }
      }
      else if (Platform.isIOS) {
        openPDF(context, data.resource_url);
      }
    },
  );
}


void openPDF(BuildContext context, String resource_url) => Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => PDFViewerPage(resource_url: resource_url)),
);

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
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xff714CBF)))),
        );
      });
}
