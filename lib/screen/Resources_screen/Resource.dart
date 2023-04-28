import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Home/Home_screen.dart';
import 'package:nomv/screen/Resources_screen/Resource_infographics.dart';
import 'package:path/path.dart';
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

class Resources_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Resources_State();
  }
}

class Resources {
  final String resource_name;
  final String resource_url, created_at, updated_at;

  Resources(this.resource_name, this.resource_url, this.created_at, this.updated_at);

  factory Resources.fromJson(Map<String, dynamic> json) {
    return Resources(json['resource_name'], json['resource_url'], json['created_at'] , json['updated_at']);
  }
}

class Resources_State extends State<Resources_Screen> {

  List<Resources> resources_data = [];
  bool should_load_resources = false;
  late SharedPreferences pref;

  @override
  void initState() {

    Timer(Duration(milliseconds: 500), () =>
        SharedPreferences.getInstance().then((SharedPreferences sp) {
          pref = sp;
          resources_fetchdata(pref);
        }),
    );
    super.initState();
  }

  Future<List<Resources>?> resources_fetchdata(SharedPreferences sharedPreferences) async {

    if (sharedPreferences.containsKey("json_main_resource")) {
      dynamic asdd = convert.jsonDecode(sharedPreferences.getString("json_main_resource")!);
      var sponsers_array = asdd["resources"] as List;

      if (sponsers_array.isNotEmpty) {
        setState(() {
          resources_data = sponsers_array.map<Resources>((json) => Resources.fromJson(json)).toList();
          should_load_resources = true;
        });
      }
      else {
        resources_data.clear();
        return null;
      }
    }

    else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    if (should_load_resources) {
      return Stack(
        children: <Widget>[
          Image.asset(
            "assets/images/background_app.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          WillPopScope(
            // onWillPop: () async => true,
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => HomePage()),
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
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => HomePage()),
                    //     (route) => false);
                  },
                ),
                title: const Text('Resources',
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
                      itemCount: resources_data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
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
                                            resources_data[index], context)),
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
            // onWillPop: () async => true,
            onWillPop: () async {
              Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => HomePage()),
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
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => HomePage()),
                    //     (route) => false);
                  },
                ),
                title: const Text('Resources',
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
                data.resource_name.isEmpty ? "To be available soon" : data.resource_name.replaceAll("\n", " "),
                maxLines: 2,
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
      if (!data.resource_name.toString().contains("NOMV Infographic (available in multiple languages*)")) {
        if (Platform.isAndroid) {
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt > 29) {
            if (await Permission.manageExternalStorage.isGranted) {
              openPDF(context, data.resource_url);
            }
          }
          else {
            if (await Permission.storage.isGranted) {
              openPDF(context, data.resource_url);
            }
          }
        }
        else if (Platform.isIOS) {
          openPDF(context, data.resource_url);
        }
      }
      else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Resources_infographics(
            heading_name: data.resource_name.isEmpty
                ? "To be available soon"
                : "NOMV Infographic")),);
      }
    },
  );
}


void openPDF(BuildContext context, String resource_url) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFViewerPage(resource_url: resource_url )),);
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



