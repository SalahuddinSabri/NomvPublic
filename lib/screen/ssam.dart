import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Resources_screen/resource_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/const.dart';
import '../city/city_selector.dart';
import '../country/country_selector.dart';
import '../states/state_selector.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Filter_Screen extends StatefulWidget {
  @override
  _Filter_ScreenState createState() => _Filter_ScreenState();
}

class _Filter_ScreenState extends State<Filter_Screen> {
  String countryValue = "";
  String stateValue = "";
  String resource_type = "";
  String cityValue = "";
  bool should_load = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // SharedPreferences sharedPreferences;

    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      if (sharedPreferences.containsKey("filter_countryname")) {
        countryValue = sharedPreferences.getString("filter_countryname")!;
      } else {
        countryValue = "";
      }

      //city
      if (sharedPreferences.containsKey("filter_cityname")) {
        cityValue = sharedPreferences.getString("filter_cityname")!;
      } else {
        cityValue = "";
      }
      //state

      if (sharedPreferences.containsKey("filter_statename")) {
        stateValue = sharedPreferences.getString("filter_statename")!;
      } else {
        stateValue = "";
      }

      //resource
      if (sharedPreferences.containsKey("filter_resource")) {
        resource_type = sharedPreferences.getString("filter_resource")!;
      } else {
        resource_type = "";
      }

      setState(() {
        should_load = true;
      });
      print(
          "checkif    $countryValue    $cityValue    $stateValue   $resource_type");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    if (should_load) {
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
              // SharedPreferences pref = await shared_pref;
              /*              if (pref.containsKey("filter_countryname")) {
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

              countryValue="";
              stateValue="";
              cityValue="";
              resource_type="";*/
              Navigator.pop(context, false);
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
                    child: TextButton(
                        onPressed: () {

                          print("getvalue   ${sharedPreferences.containsKey("filter_countryname")}    ${sharedPreferences.containsKey("filter_cityname")} ${sharedPreferences.containsKey("filter_statename")}   ${sharedPreferences.containsKey("filter_resource")}");
                          //
                          // if (countryValue.isNotEmpty && cityValue.isNotEmpty && stateValue.isNotEmpty && resource_type.isNotEmpty) {
                          //   Navigator.pop(context, true);
                          // } else {
                          //   Fluttertoast.showToast(
                          //       msg: "Fields are required..!!",
                          //       toastLength: Toast.LENGTH_SHORT,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIosWeb: 1,
                          //       backgroundColor: Color(0xff586BC6),
                          //       textColor: Colors.white,
                          //       fontSize: 16.0);
                          // }
                          Navigator.pop(context, true);
                        },
                        child: Text("Done",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Karla',
                                color: Color(0xff85E189).withOpacity(1),
                                fontWeight: FontWeight.w600))),
                  ),
                ],
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/filter_screen_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                leading: IconButton(
                  constraints: BoxConstraints(maxHeight: 36),
                  icon: Image.asset(
                    'assets/images/back_menu.png',
                    height: 13,
                    width: 13,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    // SharedPreferences pref = await shared_pref;
                    /*  if (pref.containsKey("filter_countryname")) {
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

                    countryValue="";
                    stateValue="";
                    cityValue="";
                    resource_type="";*/

                    Navigator.pop(context, true);
                  },
                ),

                title: const Text('Filter',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 33, 36, 1))),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/filter_screen_background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => country_selector())).then((value) async {
                                  SharedPreferences pref = await shared_pref;

                                  print("country_valueis   $value");

                                  if (value != null) {
                                    if (!value.isEmpty) {
                                      if (value.contains("json_citystate")) {
                                        setState(() {
                                          if (pref.containsKey("selected_city")) {
                                            pref.remove("selected_city");
                                          }
                                          if (pref.containsKey("selected_resource")) {
                                            pref.remove("selected_resource");
                                          }
                                          if (pref.containsKey("selected_statename")) {
                                            pref.remove("selected_statename");
                                          }
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

                                          should_load = true;
                                          cityValue="";
                                          resource_type="";
                                          stateValue="";
                                          countryValue = pref.getString("filter_countryname")!;
                                          print("called_vlu   $value");
                                        });
                                        get_statecity(sharedPreferences, pref.getInt("filter_countryid")! , pref.getString("filter_countryname")!);
                                      }

                                      else{
                                        setState(() {

                                          if (pref.containsKey("selected_city")) {
                                            pref.remove("selected_city");
                                          }
                                          if (pref.containsKey("selected_resource")) {
                                            pref.remove("selected_resource");
                                          }
                                          if (pref.containsKey("selected_statename")) {
                                            pref.remove("selected_statename");
                                          }

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

                                          countryValue = value;
                                          should_load = true;

                                          cityValue="";
                                          resource_type="";
                                          stateValue="";

                                          countryValue = value;
                                          // refresh state of Page1
                                          print("called_vlu   $value");
                                        });
                                      }
                                    }

                                    else{
                                      countryValue = value;
                                      should_load = true;
                                    }
                                  }
                                  else{
                                    setState(() {

                                      if (pref.containsKey("filter_countryid")) {
                                        pref.remove("filter_countryid");
                                      }
                                      if (pref.containsKey("filter_countryname")) {
                                        pref.remove("filter_countryname");
                                      }

                                      if (pref.containsKey("selected_resource")) {
                                        pref.remove("selected_resource");
                                      }

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

                                      countryValue = "";
                                      cityValue="";
                                      resource_type="";
                                      stateValue="";
                                      should_load = true;
                                      print("called_vlu_country  $value    ${pref.containsKey("selected_resource")}");
                                    });
                                  }
                                });
                              },


                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 20, bottom: 0, right: 15, top: 5),
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Country",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(36, 33, 36, 1),
                                        // color: Colors.grey[700],
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        // width: 120,
                                        child: Text(
                                          countryValue.isEmpty
                                              ? "Any"
                                              : countryValue.length > 15
                                              ? countryValue.substring(
                                              0, 15) +
                                              '...'
                                              : countryValue,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                            Color.fromRGBO(45, 61, 56, 0.5),
                                            // color: Colors.grey[700],
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/front_filter.png',
                                        height: 13,
                                        width: 13,
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print("country_val  $countryValue");

                                if (countryValue.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          state_selector())).then((value) async {

                                    SharedPreferences pref = await shared_pref;
                                    if (value != null) {
                                      if (!value.isEmpty) {
                                        setState(() {
                                          stateValue = value;
                                          should_load = true;
                                          // refresh state of Page1
                                          print("called_vlu_state  $value");
                                        });
                                      } else {
                                        setState(() {
                                          // stateValue = pref.getString("filter_statename")!;
                                          stateValue = "";
                                          should_load = true;
                                          // refresh state of Page1
                                          print("called_vlu_state2   $value");
                                        });
                                      }
                                    }

                                    else{
                                      setState(() {

                                        if (pref.containsKey("selected_statename")) {
                                          pref.remove("selected_statename");
                                        }


                                        if (pref.containsKey("filter_statename")) {
                                          pref.remove("filter_statename");
                                        }
                                        stateValue = "";
                                        should_load = true;
                                        print("called_vlu_state  $value");
                                      });
                                    }










                                    /*  if (value.isEmpty) {
                                      SharedPreferences pref = await shared_pref;
                                      setState(() {

                                        */
                                    /*if (pref.containsKey("filter_countryname")) {
                                          pref.remove("filter_countryname");
                                        }
                                        if (pref.containsKey("filter_cityname")) {
                                          pref.remove("filter_cityname");
                                        }*/
                                    /*
                                        //state
                                        if (pref.containsKey("filter_statename")) {
                                          pref.remove("filter_statename");
                                        }
                                        //resource
                                       */
                                    /* if (pref.containsKey("filter_resource")) {
                                          pref.remove("filter_resource");
                                        }*/
                                    /*

                                        should_load = true;
                                        stateValue="";

                                        // refresh state of Page1
                                        print("called_vlu   $value");
                                      });
                                    }*/
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Select Country First..!!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Color(0xff586BC6),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 20, bottom: 0, right: 15, top: 5),
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  //mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "State",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(36, 33, 36, 1),
                                        // color: Colors.grey[700],
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        // width: 120,
                                        child: Text(
                                          stateValue.isEmpty
                                              ? "Any"
                                              : stateValue.length > 15
                                              ? stateValue.substring(
                                              0, 15) +
                                              '...'
                                              : stateValue,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                            Color.fromRGBO(45, 61, 56, 0.5),
                                            // color: Colors.grey[700],
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/front_filter.png',
                                        height: 13,
                                        width: 13,
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print("country_val2  $countryValue");

                                if (countryValue.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              city_selector())).then((value) async {


                                    SharedPreferences pref = await shared_pref;
                                    if (value != null) {
                                      if (!value.isEmpty) {
                                        setState(() {
                                          cityValue = value;
                                          should_load = true;
                                          // refresh state of Page1
                                          print("called_vlu   $value");
                                        });
                                      } else {
                                        setState(() {
                                          cityValue = pref.getString("filter_cityname")!;
                                          should_load = true;
                                          // refresh state of Page1
                                          print("called_vlu   $value");
                                        });
                                      }
                                    }

                                    else{
                                      setState(() {

                                        if (pref.containsKey("selected_city")) {
                                          pref.remove("selected_city");
                                        }


                                        if (pref.containsKey("filter_cityname")) {
                                          pref.remove("filter_cityname");
                                        }
                                        cityValue = "";
                                        should_load = true;
                                        print("called_vlu_state  $value");
                                      });
                                    }

                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Select Country First..!!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Color(0xff586BC6),
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 20, bottom: 0, right: 15, top: 5),
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  //mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "City",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(36, 33, 36, 1),
                                        // color: Colors.grey[700],
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        // width: 120,
                                        child: Text(
                                          cityValue.isEmpty
                                              ? "Any"
                                              : cityValue.length > 15
                                              ? cityValue.substring(0, 15) +
                                              '...'
                                              : cityValue,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                            Color.fromRGBO(45, 61, 56, 0.5),
                                            // color: Colors.grey[700],
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/front_filter.png',
                                        height: 13,
                                        width: 13,
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            resource_selector()))
                                    .then((value) async {


                                  SharedPreferences pref = await shared_pref;
                                  if (value != null) {
                                    if (!value.isEmpty) {
                                      setState(() {
                                        resource_type = value;
                                        should_load = true;
                                        // refresh state of Page1
                                        print("called_vlu   $value");
                                      });
                                    }
                                    else {
                                      setState(() {
                                        resource_type = pref.getString("filter_resource")!;
                                        should_load = true;
                                        // refresh state of Page1
                                        print("called_vlu   $value");
                                      });
                                    }
                                  }


                                  else{
                                    setState(() {

                                      if (pref.containsKey("selected_resource")) {
                                        pref.remove("selected_resource");
                                      }
                                      if (pref.containsKey("filter_resource")) {
                                        pref.remove("filter_resource");
                                      }
                                      resource_type = "";
                                      should_load = true;
                                      print("called_vlu_resource $value");
                                    });
                                  }









                                  /* if (value != null) {
                                    setState(() {
                                      resource_type = value;
                                      // refresh state of Page1
                                      print("called_vlu   $value");
                                    });
                                  }*/
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 20, bottom: 0, right: 15, top: 5),
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  //mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Resource Type",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(36, 33, 36, 1),
                                        // color: Colors.grey[700],
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        // width: 120,
                                        child: Text(
                                          resource_type.isEmpty
                                              ? "Any"
                                              : resource_type.length > 15
                                              ? resource_type.substring(
                                              0, 15) +
                                              '...'
                                              : resource_type,
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                            Color.fromRGBO(45, 61, 56, 0.5),
                                            // color: Colors.grey[700],
                                            fontFamily: 'Karla',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/front_filter.png',
                                        height: 13,
                                        width: 13,
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Container(
          width: 40.0,
          height: 40.0,
          child: const CircularProgressIndicator(
              backgroundColor: Color(0xffd7b563),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),
        ),
      );
    }
  }


  Future<List<State_data>?> get_statecity(SharedPreferences sharedPreferences, int i, String countryname) async {
    bool isOnline = await globals.hasNetwork();
    if (isOnline) {
      showLoaderDialog(context);

      var requestUrl = "$base_url_listing/getStatesandcitiesbycountry?country=$countryname";
      final uri_val = await http.get(
        Uri.parse(requestUrl),
        headers: <String, String>{"Content-Type": "application/json"},
      );

      // final uri_val = await http.get(Uri.parse("$base_url_listing/getFilteredCountryData?country_id=$i"), headers: <String, String>{"Content-Type": "application/json"},);
      if (uri_val.statusCode == 200) {
        dynamic asdd = convert.jsonDecode(uri_val.body);
        if (asdd.containsKey('success') == true) {

          if (sharedPreferences.containsKey("json_citystate")) {
            sharedPreferences.remove("json_citystate");
          }
          sharedPreferences.setString("json_citystate", uri_val.body);
          if (sharedPreferences.containsKey("json_citystate")) {
            Navigator.pop(context, sharedPreferences.containsKey("filter_countryname") ? sharedPreferences.getString("filter_countryname") : "");
          }
        }
      }
    }
    else {
      Navigator.pop(context);
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
