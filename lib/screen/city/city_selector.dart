import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Utils/const.dart';
import '../aboutus/filter_screen.dart';

class city_selector extends StatefulWidget {
  @override
  _city_selectorState createState() => _city_selectorState();
}

class City_Data {
  final String City;

  City_Data(this.City);

  factory City_Data.fromJson(Map<String, dynamic> json) {
    return City_Data(json['City']);
  }
}

class City_All_country {
  final String City;

  City_All_country(this.City);

  factory City_All_country.fromJson(Map<String, dynamic> json) {
    return City_All_country(json['City']);
  }
}

class _city_selectorState extends State<city_selector> {
  bool should_load = false;
  List<City_Data> city_select = [];
  List<City_All_country> city_select_all_country = [];
  List<String> filtered_city_select = [];
  List<String> tempList_state = [];
  String _selectedDestination_city="";
  late SharedPreferences pref;
  TextEditingController txtQuery = new TextEditingController();
  List<String> filteredBreeds = <String>[];

  String state_value = "";
  String countryValue_state = "";

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      pref = sp;

      state_value="";
      if (pref.containsKey("filter_statename")) {
        state_value = pref.getString("filter_statename")!;
      } else {
        state_value = "";
      }

      countryValue_state="";
      if (pref.containsKey("filter_countryname")) {
        countryValue_state = pref.getString("filter_countryname")!;
      } else {
        countryValue_state = "";
      }
      print("all_city_data222   $state_value     $countryValue_state");

      if (state_value.isNotEmpty) {
        get_city(context,state_value);
      } else if (countryValue_state.isNotEmpty) {
        get_city_bycountry(context,countryValue_state);
      }
    });
  }

  Future<List<City_Data>?> get_city(BuildContext context, String state_value) async {

    if (pref.containsKey("unselected_index_city") && pref.containsKey("selected_city")) {
      pref.remove("unselected_index_city");
      pref.setInt("unselected_index_city", -1);
      _selectedDestination_city= pref.getString("filter_cityname")!;
    } else {
      pref.setInt("unselected_index_city", -1);
      _selectedDestination_city= "";
    }



    if (pref.containsKey("json_city_by_state")) {
      dynamic asdd = convert.jsonDecode(pref.getString("json_city_by_state")!);
      if (asdd.containsKey('success') == true) {
        var state_data_updated = asdd["cities"] as List;
        print("all_city_data   ${state_data_updated.length}");

        if (state_data_updated.isNotEmpty) {
          filtered_city_select.clear();
          tempList_state.clear();
          city_select.clear();

          setState(() {
            city_select = state_data_updated.map<City_Data>((json) => City_Data.fromJson(json)).toList();
            if (city_select.isNotEmpty) {
              for (int k = 0; k < city_select.length; k++) {
                String filtered = city_select[k].City;
                filtered_city_select.add(filtered);
              }

              tempList_state.addAll(filtered_city_select);
              print("city_data43 :-  ${filtered_city_select.length}    ${tempList_state.length} ");
            }
            should_load = true;
          });
          // Navigator.pop(context);
        }
        else {
          // Navigator.pop(context);
          setState(() {
            filtered_city_select.clear();
            should_load = true;
          });
          return null;
        }
      }
    } else {
      // Navigator.pop(context);
      setState(() {
        filtered_city_select.clear();
        should_load = true;
      });
      return null;
    }
  }



  Future<List<City_All_country>?> get_city_bycountry(BuildContext context, String countryValue_state) async {

    if (pref.containsKey("unselected_index_city") && pref.containsKey("selected_city")) {
      pref.remove("unselected_index_city");
      pref.setInt("unselected_index_city", -1);
      _selectedDestination_city= pref.getString("filter_cityname")!;
    } else {
      pref.setInt("unselected_index_city", -1);
      _selectedDestination_city= "";
    }
      // showLoaderDialog(context);

      if (pref.containsKey("json_citystate")) {
        dynamic asdd = convert.jsonDecode(pref.getString("json_citystate")!);

        if (asdd.containsKey('success') == true) {
          var state_data_updated = asdd["cities"] as List;
          if (state_data_updated.isNotEmpty) {
            filtered_city_select.clear();
            tempList_state.clear();
            city_select.clear();

            setState(() {
              city_select_all_country = state_data_updated.map<City_All_country>((json) => City_All_country.fromJson(json)).toList();
              if (city_select_all_country.isNotEmpty) {
                for (int k = 0; k < city_select_all_country.length; k++) {
                  String filtered = city_select_all_country[k].City;
                  filtered_city_select.add(filtered);
                }

                tempList_state.addAll(filtered_city_select);
                print("city_data43 :-  ${filtered_city_select.length}    ${tempList_state.length} ");
              }
              should_load = true;
            });
            // Navigator.pop(context);
          }
          else {
            // Navigator.pop(context);
            setState(() {
              filtered_city_select.clear();
              should_load = true;
            });
            return null;
          }
        }
      }
      else {
        // Navigator.pop(context);
        setState(() {
          filtered_city_select.clear();
          should_load = true;
        });
        return null;
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
            // pref.setInt("unselected_index_city", -1);
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
                        // if (pref.getInt("unselected_index_city") == -1) {
                        //   Navigator.pop(context, null);
                        // }
                        //
                        // else

                        if (pref.containsKey("filter_cityname")) {
                          Navigator.pop(context, pref.containsKey("filter_cityname") ? pref.getString("filter_cityname") : null);
                        }
                        else {
                          Navigator.pop(context, null);
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
                  Navigator.pop(context, "");
                },
              ),
              title: const Text('City',
                  style: TextStyle(
                      fontFamily: 'Karla',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(36, 33, 36, 1))),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),


            body: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: <Widget>[
                    searchBarUI(),
                    /*const SizedBox(
                      height: 20,
                    ),*/

                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        // margin: EdgeInsets.only(top: 10),

                        child: filtered_city_select.isNotEmpty && filtered_city_select!=null
                            ? ListView.builder(
                            itemCount: filtered_city_select.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                // margin: EdgeInsets.only(left: 10, right: 10),
                                height: 65,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // padding: EdgeInsets.all(8),
                                          //   padding: EdgeInsets.only(bottom: 8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: _selectedDestination_city.contains(filtered_city_select[index]) ? Color.fromRGBO(112, 197, 171, 1): Colors.transparent,
                                            ),

                                            child: ListTile(
                                              dense: true,
                                              minVerticalPadding: 0,
                                              contentPadding: EdgeInsets.only(left: 10), visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                                              title: Container(
                                                margin: EdgeInsets.only(left: 10),
                                                child: new Text(
                                                    filtered_city_select[index],
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                        'assets/fonts/lato.ttf',
                                                        color: _selectedDestination_city.contains(filtered_city_select[index]) ? Color.fromRGBO(255, 255, 255, 1): Color.fromRGBO(36, 33, 36, 1),
                                                        fontWeight:
                                                        FontWeight.w400)),
                                              ),
                                              // select_resource

                                              selected: !_selectedDestination_city.contains(filtered_city_select[index]),

                                              // tileColor: _selectedDestination_city == index ? Color.fromRGBO(112, 197, 171, 1): Colors.transparent,

                                              trailing: Visibility(
                                                visible:
                                                _selectedDestination_city.contains(filtered_city_select[index]),
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
                                                SharedPreferences pref =
                                                await shared_pref;
                                                if (pref.containsKey("filter_cityname") && pref.containsKey("selected_city")) {
                                                  pref.remove("filter_cityname");
                                                  pref.remove("selected_city");
                                                }
                                                pref.setString("filter_cityname", filtered_city_select[index]);
                                                pref.setInt("selected_city", index);
                                                selectDestination(filtered_city_select[index]);
                                                log("index_val" + filtered_city_select[index]);
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            : Visibility(
                          visible: should_load,
                          child: Center(child: Text(
                            "No city found.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                              fontFamily: 'Karla',
                            ),
                          ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),

          ),
        ),
      ],
    );
  }

  Widget searchBarUI() {
    return Container(

      margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage("assets/images/search_field.png" , ),
          fit: BoxFit.fitHeight,
        ),
      ),

      child: Container(
        child: TextFormField(
          controller: txtQuery,
          onChanged: filterSearchResults,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(15), hintText: "Search",
            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            // prefixIcon: Icon(Icons.search),
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



  void selectDestination(String index) {
    if (index.isNotEmpty) {
      print("index_val7 :-  $_selectedDestination_city      $index ");
      if (_selectedDestination_city == index) {
        setState(() {
          _selectedDestination_city = "";
          pref.setString("filter_cityname", _selectedDestination_city);
          print("index_val77 :-  ${pref.getString("filter_cityname")} ");
        });
      }
      else {
        setState(() {
          _selectedDestination_city = index;
          pref.setString("filter_cityname", index);
          print("index_val7788 :-  ${pref.getString("filter_cityname")} ");
        });
      }
    }
    else{
      print("index_val777 :-  ${pref.getString("filter_cityname")} ");
      setState(() {
        _selectedDestination_city = index;
        print("index_val77777 :-  $_selectedDestination_city ");
      });
    }
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];

    dummySearchList.addAll(filtered_city_select);

    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if(item.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filtered_city_select.clear();
        should_load=true;
        filtered_city_select.addAll(dummyListData);
        selectDestination("");

        print("city_data6 :-  ${filtered_city_select.length}");
      });
      return;
    }

    else {
      setState(() {
        filtered_city_select.clear();
        filtered_city_select.addAll(tempList_state);
        should_load=true;
        selectDestination(pref.getString("filter_cityname")!);
        print("city_data7 :-  ${filtered_city_select.length}");
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



