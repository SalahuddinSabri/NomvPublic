import 'dart:convert';
import 'dart:developer';

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../Utils/const.dart';

class Sponsers extends StatefulWidget {
  @override
  Sponsers_State createState() => Sponsers_State();
}

class Sponsers_data {
  final String comp_name;
  final String comp_url;
  final String image_url;

  Sponsers_data(this.comp_name, this.comp_url, this.image_url);

  factory Sponsers_data.fromJson(Map<String, dynamic> json) {
    return Sponsers_data(
      json['comp_name'],
      json['comp_url'],
      json['image_url'],
    );
  }
}

class Sponsers_State extends State<Sponsers> {
  bool should_load_sponser = false;
  List<Sponsers_data> sponsers_data = [];

  @override
  void initState() {
    super.initState();
    sponsers_fetchdata();
  }

  Future<List<Sponsers_data>?> sponsers_fetchdata() async {
    bool isOnline = await globals.hasNetwork();
    if (isOnline) {
      final uri_val = await http.get(
        Uri.parse("${base_url}sponsers"),
        headers: <String, String>{"Content-Type": "application/json"},
      );

      if (uri_val.statusCode == 200) {
        dynamic asdd = convert.jsonDecode(uri_val.body);

        if (asdd.containsKey('success') == true) {
          var sponsers_api = asdd["sponsers"] as List;

          if (sponsers_api.isNotEmpty) {
            setState(() {
              sponsers_data = sponsers_api
                  .map<Sponsers_data>((json) => Sponsers_data.fromJson(json))
                  .toList();
              should_load_sponser = true;
            });
            print("the sponser is :- ${sponsers_data.length} ");
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Internet Is Required..!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    if (should_load_sponser) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        // appBar: new AppBar(
        //   centerTitle: true,
        //   iconTheme: IconThemeData(color: Colors.white),
        //   title: const Text('Sponsors',
        //       style: TextStyle(fontFamily: 'Karla', color: Colors.white)),
        //   automaticallyImplyLeading: true,
        //   backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),
        // ),

        appBar: new AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            constraints: BoxConstraints(maxHeight: 36),
            icon: Image.asset(
              'assets/images/menu.png',
              height: 20,
              width: 20,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Sponsors',
              style: TextStyle(
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: _buildList(sponsers_data),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(34, 41, 72, 0.9),

        appBar: new AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            constraints: BoxConstraints(maxHeight: 36),
            icon: Image.asset(
              'assets/images/menu.png',
              height: 20,
              width: 20,
              color: Colors.white,
              fit: BoxFit.cover,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Sponsors',
              style: TextStyle(
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                      height: 40.0,
                      width: 40.0,
                      child: Align(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red)))),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _buildList extends StatelessWidget {
  List<Sponsers_data> mList_sponsers = [];

  _buildList(List<Sponsers_data> mList) {
    this.mList_sponsers = mList;

    print("the sponsers is :- ${mList_sponsers.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (mList_sponsers != null && mList_sponsers.isNotEmpty) {
      return ListView.builder(
          itemCount: mList_sponsers.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              height: 140,
              child: ExpandTapWidget(
                onTap: () {
                  _launchURL( mList_sponsers[index].comp_url);
                },
                tapPadding: EdgeInsets.all(0.0),
                child: Card(
                  color: Colors.transparent,
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(70, 90, 165, 1).withOpacity(0.5),
                          Color.fromRGBO(32, 49, 112, 1).withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 0.2.toInt(),
                          child: Container(
                            width: 100,
                            height: 80,
                            child: CircleAvatar(
                              foregroundImage: NetworkImage("${mList_sponsers[index].image_url}" , ),
                              ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              child: SponserListTile(
                                  mList_sponsers[index].comp_name,
                                  mList_sponsers[index].comp_url,
                                  context)),
                        ),


                        Container(
                          padding: EdgeInsets.only(left: 0, bottom: 10, right: 20, top: 10),
                          alignment: Alignment.bottomRight,

                          child : Container(
                            width: 20,
                            height: 20,
                            child: ShaderMask(
                              child: Image(
                                image: AssetImage("assets/images/more.png"),
                              ),
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: [Colors.white, Colors.white],
                                  stops: [
                                    0.0,
                                    0.5,
                                  ],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return Container(
        child: Center(
          child: Text(
            "No Data Found...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontFamily: 'Karla',
            ),
          ),
        ),
      );
    }
  }
}



class SponserListTile extends ListTile {
  SponserListTile(String comp_name, String comp_url, BuildContext context)
      : super(
            title: ExpandTapWidget(
              tapPadding: EdgeInsets.only(),
              onTap: () {
                _launchURL(comp_url);
              },

              child: Container(
                child: Wrap(
                  direction: Axis.vertical, //Vertical || Horizontal
                  children: <Widget>[
                    // Sponsers_data(this.comp_name, this.comp_url, this.image_url);

                     SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child:
                      Text(
                        comp_name.length > 50 ? comp_url.substring(0, 40)+'...' : comp_name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'Karla',
                        ),
                      ),
                    ),


                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        comp_url.length > 40 ? comp_url.substring(0, 30)+'...' : comp_url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.lightBlue[200],
                          fontFamily: 'Karla',
                        ),
                      ),
                    ),

                 /*   ExpandTapWidget(
                      onTap: () {
                        _launchURL(comp_url);
                      },
                      tapPadding: EdgeInsets.all(25.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          comp_url.length > 40 ? comp_url.substring(0, 30)+'...' : comp_url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.lightBlue[200],
                            fontFamily: 'Karla',
                          ),
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            dense: false,
            onTap: () {});
}

 void _launchURL(String comp_url) async {
await launch(comp_url);
}