import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/home_data.dart';
import 'Utils/const.dart';
import 'aboutus/filter_screen.dart';

class resource_selector extends StatefulWidget {
  @override
  _resource_selectorState createState() => _resource_selectorState();
}

class _resource_selectorState extends State<resource_selector> {
  TextEditingController txtQuery_resource = new TextEditingController();
  int _selectedDestination_resource = -1;

  bool should_load_resource = false;
  List<String> tempList_resource = [];
  List<String> filtered_resource = [];

  late SharedPreferences pref_resource;


  List<String> mainDataList = [
    "NOMV Waiting Room Poster",
    "NOMV Trifold Brochure",
    "NOVMV Student Toolkit",
    "NOMV Infographic",
    "NOMV Trifold Brochure",
    "NOMV Waiting Room Poster",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }

  void onLayoutDone(Duration timeStamp) async {
    pref_resource = await shared_pref;
    get_all_resourcetype(context);
  }

  Future<List<String>?> get_all_resourcetype(BuildContext context) async {
    if (pref_resource.containsKey("unselected_index_resource")) {
      pref_resource.remove("unselected_index_resource");
      pref_resource.setInt("unselected_index_resource", -1);
    } else {
      pref_resource.setInt("unselected_index_resource", -1);
    }

    setState(() {
      if (mainDataList.isNotEmpty) {
        for (int k = 0; k < mainDataList.length; k++) {
          String filtered= mainDataList[k];
          filtered_resource.add(filtered);
        }

        if (filtered_resource.isNotEmpty) {
          tempList_resource.addAll(filtered_resource);
          print("city_data43 :-  ${filtered_resource.length}    ${tempList_resource.length}");
        }
      }
      should_load_resource = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    if (should_load_resource) {
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
              pref_resource.setInt("unselected_index_resource", -1);
              Navigator.pop(context, null);
              return true;
            },

            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
                    child: TextButton(
                        onPressed: () {
                          if (pref_resource.getInt("unselected_index_resource") != -1) {
                            if (pref_resource.containsKey("filter_resource")) {
                              if (pref_resource
                                  .getString("filter_resource")!
                                  .isNotEmpty) {
                                print(
                                    "country_selectedname ${pref_resource.getString("filter_resource")}");

                                pref_resource.setInt("unselected_index_resource", -1);

                                Navigator.pop(
                                    context, pref_resource.getString("filter_resource"));
                              }
                            }
                            else {
                              Fluttertoast.showToast(
                                  msg: "Select Resource..!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff586BC6),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                          else {
                            Fluttertoast.showToast(
                                msg: "Select Resource..!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xff586BC6),
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text("Done",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Karla',
                                color: Color.fromRGBO(133, 225, 137, 1),
                                fontWeight: FontWeight.bold))),
                  ),
                ],
                leading: IconButton(
                  constraints: BoxConstraints(maxHeight: 36),
                  icon: Image.asset(
                    'assets/images/filter_back.png',
                    height: 12,
                    width: 12,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    pref_resource.setInt("unselected_index_resource", -1);
                    Navigator.pop(context, null);
                  },
                ),
                title: const Text('Resource',
                    style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 33, 36, 1))),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              ),

              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Image.asset('assets/among.png',fit: BoxFit.cover,),
                    searchBarUI(),

                    Expanded(
                        child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: ListView.builder(
                          itemCount: filtered_resource.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 80,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          child: ListTile(
                                        dense: true,
                                        minVerticalPadding: 0,
                                        contentPadding:
                                            EdgeInsets.only(left: 5),
                                        visualDensity: VisualDensity(
                                            horizontal: 0, vertical: 4),
                                        title: Container(
                                          // margin: EdgeInsets.only(top: 15),
                                          child: new Text(
                                              filtered_resource[index],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily:
                                                      'assets/fonts/lato.ttf',
                                                  color: Color.fromRGBO(
                                                      36, 33, 36, 1),
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),

                                        // selected: _selectedDestination_1 == 0,
                                        tileColor:
                                            _selectedDestination_resource == index
                                                ? Colors.blue
                                                : Colors.transparent,

                                        trailing: Visibility(
                                          visible:
                                          _selectedDestination_resource == index,
                                          child: Container(
                                            height: 50.0,
                                            width: 50.0,
                                            child: Image.asset(
                                              "assets/images/selected_img.png",
                                              height: 50.0,
                                              width: 50.0,
                                            ),
                                          ),
                                        ),

                                        onTap: () async {
                                          SharedPreferences pref = await shared_pref;
                                          if (pref.containsKey("filter_resource")) {
                                            pref.remove("filter_resource");
                                          }
                                          pref.setString("filter_resource", filtered_resource[index]);
                                          selectDestination(index);
                                          log("index_val" + filtered_resource[index]);
                                        },
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )),
                  ],
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF),),)),
      );
    }
  }

  Widget searchBarUI() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: txtQuery_resource,
        onChanged: filterSearchResults_resource,
        decoration: InputDecoration(
          hintText: "Search",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Image.asset(
              'assets/images/microphone.png',
              height: 50,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  void filterSearchResults_resource(String query) {
    List<String> dummySearchList = <String>[];

    dummySearchList.addAll(filtered_resource);

    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filtered_resource.clear();
        should_load_resource = true;
        filtered_resource.addAll(dummyListData);
        print("city_data6 :-  ${filtered_resource.length}");
      });
      return;
    } else {
      setState(() {
        filtered_resource.clear();
        filtered_resource.addAll(tempList_resource);
        should_load_resource = true;
        print("city_data7 :-  ${filtered_resource.length}");
      });
    }
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination_resource = index;
      pref_resource.setInt("unselected_index_resource", index);
    });
  }
}

