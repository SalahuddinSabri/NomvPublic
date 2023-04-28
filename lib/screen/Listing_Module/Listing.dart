import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../Home/home_data.dart';
import '../Utils/const.dart';
import '../aboutus/filter_screen.dart';

class Listing extends StatefulWidget {

  @override
  Listing_State createState() => Listing_State();
}

class Listing_data {
  final String city, state, country, resource_name;
  final String nomv_url, brief_description, resource_category, icon;

  Listing_data(this.city, this.state, this.country, this.resource_name,
      this.nomv_url, this.brief_description, this.resource_category, this.icon);

  factory Listing_data.fromJson(Map<String, dynamic> json) {
    return Listing_data(
        json['City'],
        json['State'],
        json['County'],
        json['Resources_Name'],
        json['NOMV_URL'],
        json['Brief_description'],
        json['Resource_Category'],
        json['Icon']);
  }
}

class Listing_State extends State<Listing> {
  String countryValue = "";
  String stateValue = "";
  String resource_type = "";
  String cityValue = "";
  bool should_load = false;

  List<String> svg_file= [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<Listing_data>?> listing_fetchdata() async {

    SharedPreferences pref = await shared_pref;

    countryValue="";
    stateValue="";
    cityValue="";
    resource_type="";

    if (pref.containsKey("filter_countryname")) {
      countryValue = pref.getString("filter_countryname")!;
    }
    //city
    if (pref.containsKey("filter_cityname")) {
      cityValue = pref.getString("filter_cityname")!;
    }
    //state
    if (pref.containsKey("filter_statename")) {
      stateValue = pref.getString("filter_statename")!;
    }
    //resource
    if (pref.containsKey("filter_resource")) {
      resource_type = pref.getString("filter_resource")!;
    }

    print("all_listing333    $countryValue    $cityValue    $stateValue   $resource_type");

    // svg_file.clear();
    if (countryValue.isEmpty && cityValue.isEmpty && stateValue.isEmpty && resource_type.isEmpty) {

      // if (pref.containsKey("listings_svgs")) {
      //   svg_file = pref.getStringList("listings_svgs")!;
      // } else {
      //   svg_file.clear();
      // }
      //
      // print("svg_file_size ${svg_file.length}");

      if (pref.containsKey("json_listings_data")) {
        dynamic asdd = convert.jsonDecode(pref.getString("json_listings_data")!);
        if (asdd.containsKey('success') == true) {
          var listings_data = asdd["listings"] as List;

          if (listings_data.isNotEmpty) {
            return listings_data.map<Listing_data>((json) => Listing_data.fromJson(json)).toList();
          }
          else {
            return null;
          }
        }
      }

      else{
        bool isOnline = await globals.hasNetwork();
        if (isOnline) {
          var requestUrl = "$base_url_listing/filteredListings?city=$cityValue&state=$stateValue&country=$countryValue&resource_name=$resource_type";
          final uri_val = await http.get(Uri.parse(requestUrl), headers: <String, String>{"Content-Type": "application/json"},);
          if (uri_val.statusCode == 200) {
            dynamic asdd = convert.jsonDecode(uri_val.body);
            if (asdd.containsKey('success') == true) {
              var listings_data = asdd["listings"] as List;
              print("all_listing339    ${listings_data.length}");

              if (listings_data.isNotEmpty) {
                // svg_file.clear();
                return listings_data.map<Listing_data>((json) => Listing_data.fromJson(json)).toList();
              } else {
                return null;
              }
            }
          }
          else{
            return null;
          }
        }
        else {
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
    }

    else {
      bool isOnline = await globals.hasNetwork();
      if (isOnline) {
        var requestUrl = "$base_url_listing/filteredListings?city=$cityValue&state=$stateValue&country=$countryValue&resource_name=$resource_type";
        final uri_val = await http.get(Uri.parse(requestUrl), headers: <String, String>{"Content-Type": "application/json"},);
        if (uri_val.statusCode == 200) {
          dynamic asdd = convert.jsonDecode(uri_val.body);
          if (asdd.containsKey('success') == true) {
            var listings_data = asdd["listings"] as List;
            print("all_listing339    ${listings_data.length}");

            if (listings_data.isNotEmpty) {
              // svg_file.clear();
              return listings_data.map<Listing_data>((json) => Listing_data.fromJson(json)).toList();
            } else {
              return null;
            }
          }
        }
        else{
          return null;
        }
      }
      else {
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
  }



  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: IconButton(
              constraints: BoxConstraints(maxHeight: 36),
              icon: Image.asset(
                'assets/images/filter_icon.png',
                height: 20,
                width: 20,
                // color: Colors.white,
                fit: BoxFit.cover,
              ),
              onPressed: () async {

                Navigator.push(context, MaterialPageRoute(builder: (context) => Filter_Screen())).then((value) {
                  if (value) {
                    setState(() {
                      should_load = value;
                    });
                  }
                });
              },
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/listing_background.png'),
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
          },
        ),
        title: const Text('Listings',
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
        child: FutureBuilder(
            future: listing_fetchdata(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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

                  return Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20 , top: 10 , bottom: 10),
                        child: Text('NOMV\u0027s List is a searchable resource database created by gathering peer recommended resources. NOMV\u0027s List includes international wellbeing resources and was built by veterinary professionals for veterinary professionals.',

                            softWrap: true,
                            maxLines: 6,
                            // textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Karla',
                                fontSize: 15.0,
                                color: Color.fromRGBO(95, 128, 118, 1)
                            )),
                      ),

                      Expanded(
                        child: RawScrollbar(
                          thumbColor: Color(0xff4AB890),
                          radius: Radius.circular(10),
                          thickness: 5,
                          minThumbLength: 70,

                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                  height: 110,
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
                                          color: Color.fromRGBO(235, 249, 240, 0.7),
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                child: Listing_Tile(snapshot.data[index], context,index)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  );


                  /*return Container(
                    margin: EdgeInsets.only(top: 15),
                    child: RawScrollbar(
                      thumbColor: Color(0xff4AB890),
                      radius: Radius.circular(10),
                      thickness: 5,
                      minThumbLength: 70,

                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 20, right: 20),
                              height: 110,
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
                                      color: Color.fromRGBO(235, 249, 240, 0.7),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            child: Listing_Tile(snapshot.data[index], context,index)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  );*/
                }
              } else {
                return Center(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    child: const CircularProgressIndicator(
                        backgroundColor: Color(0xffd7b563),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),
                  ),
                );
              }
            }),
      ),
    );
  }
}

Widget Listing_Tile(Listing_data data, BuildContext context,int indexx) {

  return new ListTile(
    leading: ClipRRect(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xff85E189),
                Color(0xff70C5AB),
                // Color.fromRGBO(130, 52, 243, 1),
              ],
            )),
        child: Container(
          // child: Image.asset("https://tech.celeritasdigital.com/nomv-apis/icons/${data.icon}" , scale: 15,),

            child: Container(
              color: Colors.transparent,

               child : Transform.scale(
                  scale: 0.6,
                    child: SvgPicture.network('https://apis.celeritasdigital.com/nomv-apis/icons/${data.icon!=null && !data.icon.contains("Other-NOMV-List.svg;Crisis-Line-NOMV-List.svg") ? data.icon : 'Food-Bank-NOMV-List.svg'}',
                        fit: BoxFit.fill,
                        height: 25,
                        width: 25,
                        placeholderBuilder: (BuildContext context) =>
                        Container(
                          height: 25,
                          width: 25,
                          child: const CircularProgressIndicator(
                          backgroundColor: Color(0xffd7b563),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),
                        )
                    ),
                )
              ),
            ))),




      title: Container(
        margin: EdgeInsets.only(right: 5, top: 5),
        child: new Text(
          data.resource_name == null
              ? "To be available soon"
              : data.resource_name,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(112, 197, 171, 1),
            fontFamily: 'Karla',
          ),
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(right: 5),
        child: Text(
          data.brief_description == null
              ? "To be available soon"
              : data.brief_description,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(95, 128, 118, 1),
            fontFamily: 'Lato',
          ),
        ),
      ),

      onTap: () async {
        launchURL(data.nomv_url);
      },
      );
}

launchURL(String url) async {
  if (await launch(url)) {
    await canLaunch(url);
  } else {
    throw 'Could not launch $url';
  }
}

var gradient = [
  BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [
      Color(0xff85E189),
      Color(0xff70C5AB),
    ],
  )),
];
