import 'dart:convert';
import 'dart:developer';

import 'package:analyzer/file_system/file_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Home/home_data.dart';
import '../Utils/const.dart';
import '../aboutus/filter_screen.dart';

class resource_selector extends StatefulWidget {
  @override
  _resource_selectorState createState() => _resource_selectorState();
}

class Resources_Selector {
  final String Resource_Category;

  Resources_Selector(this.Resource_Category);

  factory Resources_Selector.fromJson(Map<String, dynamic> json) {
    return Resources_Selector(json['Resource_Category']);
  }
}


class _resource_selectorState extends State<resource_selector> {
  TextEditingController txtQuery_resource = new TextEditingController();
  String _selectedDestination_resource = "";
  bool should_load_resource = false;
  List<String> tempList_resource = [];
  List<String> filtered_resource = [];

  List<Resources_Selector> resource_data = [];
  String countryValue = "";
  late SharedPreferences pref_resource;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      pref_resource = sp;
      get_all_resourcetype(context);
      // WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
    });
  }


  Future<List<Resources_Selector>?> get_all_resourcetype(BuildContext context) async {

    if (pref_resource.containsKey("unselected_index_resource")  && pref_resource.containsKey("selected_resource")) {
      pref_resource.remove("unselected_index_resource");
      pref_resource.setInt("unselected_index_resource", -1);
      _selectedDestination_resource= pref_resource.getString("filter_resource")!;
    } else {
      pref_resource.setInt("unselected_index_resource", -1);
      _selectedDestination_resource= "";
    }

    print("index_val88  $_selectedDestination_resource");

    countryValue="";
    if (pref_resource.containsKey("filter_countryname")) {
      countryValue = pref_resource.getString("filter_countryname")!;
    }
    else {
      countryValue = "";
    }
    print("all_resources2  $_selectedDestination_resource   $countryValue     ${pref_resource.containsKey("json_citystate")}""${pref_resource.containsKey("json_all_resources_data")}");


    if (countryValue.isNotEmpty) {
      if (pref_resource.containsKey("json_citystate")) {
        dynamic asdd = convert.jsonDecode(pref_resource.getString("json_citystate")!);
        if (asdd.containsKey('success') == true) {
          var sponsers_array = asdd["resource_type"] as List;
          if (sponsers_array.isNotEmpty) {
            filtered_resource.clear();
            tempList_resource.clear();
            resource_data.clear();

            setState(() {
              resource_data = sponsers_array
                  .map<Resources_Selector>(
                      (json) => Resources_Selector.fromJson(json))
                  .toList();
              if (resource_data.isNotEmpty) {
                for (int k = 0; k < resource_data.length; k++) {
                  String filtered = resource_data[k].Resource_Category;
                  filtered_resource.add(filtered);
                }

                tempList_resource.addAll(filtered_resource);
                print(
                    "city_data43 :-  ${filtered_resource.length}    ${tempList_resource.length} ");
              }
              should_load_resource = true;
            });
            // Navigator.pop(context);
          } else {
            return null;
          }
        }
      }
      else{
        dynamic asdd = convert.jsonDecode(pref_resource.getString("json_all_resources_data")!);
        if (asdd.containsKey('success') == true) {
          var sponsers_array = asdd["resource_type"] as List;
          if (sponsers_array.isNotEmpty) {
            filtered_resource.clear();
            tempList_resource.clear();
            resource_data.clear();

            setState(() {
              resource_data = sponsers_array.map<Resources_Selector>((json) => Resources_Selector.fromJson(json)).toList();
              if (resource_data.isNotEmpty) {
                for (int k = 0; k < resource_data.length; k++) {
                  String filtered = resource_data[k].Resource_Category;
                  filtered_resource.add(filtered);
                }

                tempList_resource.addAll(filtered_resource);
                print(
                    "city_data43 :-  ${filtered_resource.length}    ${tempList_resource.length} ");
              }
              should_load_resource = true;
            });
            // Navigator.pop(context);
          } else {
            return null;
          }
        }
      }
    }
    else{
      dynamic asdd = convert.jsonDecode(pref_resource.getString("json_all_resources_data")!);
      if (asdd.containsKey('success') == true) {
        var sponsers_array = asdd["resource_type"] as List;
        if (sponsers_array.isNotEmpty) {
          filtered_resource.clear();
          tempList_resource.clear();
          resource_data.clear();

          setState(() {
            resource_data = sponsers_array.map<Resources_Selector>((json) => Resources_Selector.fromJson(json)).toList();
            if (resource_data.isNotEmpty) {
              for (int k = 0; k < resource_data.length; k++) {
                String filtered = resource_data[k].Resource_Category;
                filtered_resource.add(filtered);
              }

              tempList_resource.addAll(filtered_resource);
              print(
                  "city_data43 :-  ${filtered_resource.length}    ${tempList_resource.length} ");
            }
            should_load_resource = true;
          });
          // Navigator.pop(context);
        } else {
          return null;
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

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
            // pref_resource.setInt("unselected_index_resource", -1);
            Navigator.pop(context, "");
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

                        if (_selectedDestination_resource == "") {
                          Navigator.pop(context, null);
                        }
                        else if (pref_resource.containsKey("filter_resource")) {
                          Navigator.pop(context, pref_resource.containsKey("filter_resource") ? pref_resource.getString("filter_resource") : null);
                        }

                      },

                      child: Text("Done",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Karla',
                              color: Color(0xff85E189),
                              fontWeight: FontWeight.w600))),
                ),
              ],

              leading: IconButton(
                constraints: BoxConstraints(maxHeight: 36),
                icon: Image.asset(
                  'assets/images/back_menu.png',
                  height: 13,
                  width: 13,
                  color: Colors.black,
                ),
                onPressed: () {
                  // pref_resource.setInt("unselected_index_resource", -1);
                  Navigator.pop(context, "");
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

            body: Column(
              children: [
                // Image.asset('assets/among.png',fit: BoxFit.cover,),
                searchBarUI(),

                Expanded(
                    child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(top: 10),


                      child: filtered_resource.isNotEmpty && filtered_resource!=null
                          ? ListView.builder(
                          itemCount: filtered_resource.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 60,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: _selectedDestination_resource.contains(filtered_resource[index]) ? Color.fromRGBO(112, 197, 171, 1): Colors.transparent,
                                          ),

                                          child: ListTile(
                                            dense: true,
                                            minVerticalPadding: 0,
                                            contentPadding: EdgeInsets.only(left: 10), visualDensity: VisualDensity(horizontal: 0, vertical: 4),

                                            title: Container(
                                              margin: EdgeInsets.only(left: 10),

                                              child: new Text(
                                                  filtered_resource[index],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                      'assets/fonts/lato.ttf',
                                                      color: _selectedDestination_resource.contains(filtered_resource[index]) ? Color.fromRGBO(255, 255, 255, 1): Color.fromRGBO(36, 33, 36, 1),
                                                      fontWeight:
                                                      FontWeight.w400)),
                                            ),

                                            // tileColor: _selectedDestination_resource == index ? Color.fromRGBO(112, 197, 171, 1): Colors.transparent,
                                            selected: !_selectedDestination_resource.contains(filtered_resource[index]),


                                            trailing: Visibility(
                                              visible:
                                              _selectedDestination_resource.contains(filtered_resource[index]),
                                              child: Container(
                                                margin: EdgeInsets.only(left: 10, right: 10),
                                                height: 25.0,
                                                width: 25.0,
                                                child: Image.asset(
                                                  "assets/images/selected_img.png",
                                                  height: 25.0,
                                                  width: 25.0,
                                                ),
                                              ),
                                            ),

                                            onTap: () async {
                                              SharedPreferences pref = await shared_pref;
                                              if (pref.containsKey("filter_resource")  && pref.containsKey("selected_resource")) {
                                                pref.remove("filter_resource");
                                                pref.remove("selected_resource");
                                              }
                                              pref.setString("filter_resource", filtered_resource[index]);
                                              pref.setInt("selected_resource", index);

                                              selectDestination(filtered_resource[index]);
                                              print("index_val   ${filtered_resource[index]}    $index");
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                          : Visibility(
                        visible: should_load_resource,
                        child: Center(child: Text(
                          "No Data Found...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                            fontFamily: 'Karla',
                          ),
                        ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget searchBarUI() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage("assets/images/search_field.png" , ),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Container(
        child: TextFormField(
          controller: txtQuery_resource,
          onChanged: filterSearchResults_resource,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(15), hintText: "Search",
            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            prefixIcon: Icon(Icons.search),
            // suffixIcon: IconButton(
            //   icon: Image.asset(
            //     'assets/images/microphone.png',
            //     height: 50,
            //   ),
            //   onPressed: () {},
            // ),
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
        selectDestination("");
        print("city_data6 :-  ${filtered_resource.length}");
      });
      return;
    } else {
      setState(() {
        filtered_resource.clear();
        filtered_resource.addAll(tempList_resource);
        should_load_resource = true;
        selectDestination(pref_resource.getString("filter_resource")!);
        print("city_data7 :-  ${filtered_resource.length}");
      });
    }
  }




  void selectDestination(String index) {
    if (index.isNotEmpty) {
      print("index_val7 :-  $_selectedDestination_resource      $index ");
      if (_selectedDestination_resource == index) {
        setState(() {
          _selectedDestination_resource = "";
          pref_resource.setString("filter_resource", _selectedDestination_resource);
          print("index_val77 :-  ${pref_resource.getString("filter_resource")} ");
        });
      }
      else {
        setState(() {
          _selectedDestination_resource = index;
          pref_resource.setString("filter_resource", index);
          print("index_val7788 :-  ${pref_resource.getString("filter_resource")} ");
        });
      }
    }
    else{
      print("index_val777 :-  ${pref_resource.getString("filter_resource")} ");
      setState(() {
        _selectedDestination_resource = index;
        print("index_val77777 :-  $_selectedDestination_resource ");
      });
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


