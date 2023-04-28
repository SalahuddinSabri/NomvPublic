import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/const.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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


Future<List<About_Us>?> fetch_aboutus() async {
  List<About_Us> list_about_us;

  bool isOnline = await globals.hasNetwork();
  if (isOnline) {
    final uri_val = await http.get(
      Uri.parse("${base_url}aboutus"),
      headers: <String, String>{"Content-Type": "application/json"},
    );

    if (uri_val.statusCode == 200) {
      dynamic about_us = convert.jsonDecode(uri_val.body);

      var who = about_us["aboutus"] as List;
      list_about_us = who.map<About_Us>((json) => About_Us.fromJson(json)).toList();

      if (list_about_us.isNotEmpty) {
        print("learn_more22   ${list_about_us.length}");

        return who.map<About_Us>((json) => About_Us.fromJson(json)).toList();
      } else {
        print("learn_more23  ${list_about_us.length}");
        return null;
      }
    }
  } else {
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

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

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
              child: FutureBuilder(
                  future: fetch_aboutus(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      print("learn_more25   ${snapshot.data}");

                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: Text(
                              "No Data Found...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                                fontFamily: 'Karla',
                              ),
                            ),
                          ),
                        );
                      } else {
                        print("all_data   ${snapshot.data[0].description}");

                        return SingleChildScrollView(
                            child: Container(
                                margin: EdgeInsets.only(top:20, bottom: 10,right: 20 ,left: 20),
                                decoration: BoxDecoration(color: Color.fromRGBO(61,163,153, 0.15), borderRadius: BorderRadius.circular(15)),
                                child: Column(children: <Widget>[

                                  Container(
                                    padding: EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 10),
                                    child: DefaultTextStyle(
                                      style: TextStyle(decoration: TextDecoration.none),
                                      child: RichText(
                                        text: HTML.toTextSpan(
                                          context,
                                          snapshot.data[0].description,
                                          linksCallback: (dynamic link) {
                                            launchURL(link.toString());
                                          },
                                          defaultTextStyle: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: 'Lato',
                                            // color: Color.fromRGBO(102, 105, 114, 1),
                                          ),
                                          overrideStyle: {
                                            "p": TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Lato',
                                              // color: Color.fromRGBO(102, 105, 114, 1),
                                            ),

                                            "li": TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Lato',
                                              // color: Color.fromRGBO(102, 105, 114, 1),
                                            ),

                                            "h3": TextStyle(
                                              fontSize: 28.0,
                                              fontFamily: 'Lato',
                                              color: Color.fromRGBO(
                                                  53, 140, 156, 1),
                                            ),

                                            "a": TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Lato',
                                              color: Color.fromRGBO(
                                                  54, 72, 156, 1),
                                            ),
                                            // specify any tag not just the supported ones,
                                            // and apply TextStyles to them and/override them
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  /* child: RichText(
                                        text: HTML.toTextSpan(context, snapshot.data[0].description,
                                          linksCallback: (dynamic link) {
                                            launchURL(link.toString());
                                          },

                                          defaultTextStyle: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: 'Lato',
                                            // color: Color.fromRGBO(102, 105, 114, 1),
                                          ),
                                          overrideStyle: {
                                            "p": TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Lato',
                                              // color: Color.fromRGBO(102, 105, 114, 1),
                                            ),

                                            "h3": TextStyle(
                                              fontSize: 28.0,
                                              fontFamily: 'Lato',
                                              color: Color.fromRGBO(53, 140, 156, 1),
                                            ),

                                            "a": TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Lato',
                                              color: Color.fromRGBO(54, 72, 156, 1),
                                            ),
                                            // specify any tag not just the supported ones,
                                            // and apply TextStyles to them and/override them
                                          },
                                        ),
                                      ),*/


                                      // child: RichText(
                                      //   text: HTML.toTextSpan(context, snapshot.data[0].description,
                                      //     linksCallback: (dynamic link) {
                                      //       launchURL(link.toString());
                                      //     },
                                      //
                                      //     defaultTextStyle: TextStyle(
                                      //     fontSize: 14.0,
                                      //     fontFamily: 'Lato',
                                      //     // color: Color.fromRGBO(102, 105, 114, 1),
                                      //   ),
                                      //     overrideStyle: {
                                      //       "p": TextStyle(fontSize: 17.3),
                                      //       "a": TextStyle(color: Colors.red),
                                      //       // specify any tag not just the supported ones,
                                      //       // and apply TextStyles to them and/override them
                                      //     },
                                      //   ),
                                      // ),









                                    // child: Html(
                                    //   data: snapshot.data[0].description,
                                    //   useRichText: true,
                                    //   // shrinkToFit: true,
                                    //   customTextAlign: (_) => TextAlign.start,
                                    //
                                    //   defaultTextStyle: TextStyle(
                                    //     fontSize: 14.0,
                                    //     fontFamily: 'Lato',
                                    //     // color: Color.fromRGBO(102, 105, 114, 1),
                                    //   ),
                                    //   onLinkTap: (url) {
                                    //     launchURL(url);
                                    //   },
                                    // ),
                                ]))
                        );
                      }
                    }


                    else {
                      return Center(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          child: const CircularProgressIndicator(
                              backgroundColor: Color(0xffd7b563),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),),
                      );
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }
}

showLoaderDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
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
