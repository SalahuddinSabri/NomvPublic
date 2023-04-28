import 'dart:convert';
import 'dart:developer';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/const.dart';
import '../aboutus/filter_screen.dart';
import '../states/state_selector.dart';

class country_selector extends StatefulWidget {
  @override
  _country_selectorState createState() => _country_selectorState();
}

class Country_data {
  final int id_val;
  final String country;

  Country_data(this.id_val, this.country);

  factory Country_data.fromJson(Map<String, dynamic> json) {
    return Country_data(json['id'], json['country']);
  }
}


class _country_selectorState extends State<country_selector> {
  String countryValue = "";
  TextEditingController txtQuery = new TextEditingController();
  int _selectedDestination_1_1 = -1;

  bool should_load = false;
  List<Country_data> all_country_session = [];
  List<String> tempList = [];
  List<Country_data> filtered_country = [];

  late SharedPreferences pref;


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      pref = sp;
      get_all_countries(context);
    });
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


  Future<List<String>?> get_all_countries(BuildContext context) async {

    if (pref.containsKey("unselected_index_country") && pref.containsKey("filter_countryid")) {
      pref.remove("unselected_index_country");
      // pref.remove("filter_countryid");
      pref.setInt("unselected_index_country", -1);
      _selectedDestination_1_1= pref.getInt("filter_countryid")!;
    }
    else {
      pref.setInt("unselected_index_country", -1);
      _selectedDestination_1_1= -1;
    }
    if (pref.containsKey("json_allcountry")) {
      dynamic asdd = convert.jsonDecode(pref.getString("json_allcountry").toString());
      print("my_country    $asdd");

      var country_data = asdd["countries"] as List;
      print("my_country2    $country_data");

      if (country_data.isNotEmpty) {
        filtered_country.clear();
        tempList.clear();
        all_country_session.clear();

        setState(() {
          all_country_session = country_data.map<Country_data>((json) => Country_data.fromJson(json)).toList();
          if (all_country_session.isNotEmpty) {
            filtered_country.addAll(all_country_session);
            // tempList.addAll(filtered_country);
            print("city_data43 :-  ${filtered_country.length}    ${tempList.length}");
          }
          should_load = true;
        });
        // Navigator.pop(context);
      }
      else {
        return null;
      }
    }
    else {
      setState(() {
        filtered_country.clear();
        should_load=true;
        print("filtered_state   ${filtered_country.length}");
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
            // pref.setInt("unselected_index_country", -1);
            if (_selectedDestination_1_1 == -1) {
              if (pref.containsKey("json_citystate")) {
                pref.remove("json_citystate");
              }
            }

            Navigator.pop(context ,"");
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

                        print("country_select_val     $_selectedDestination_1_1      ${pref.getInt("filter_countryid")} ""    ${pref.getString("filter_countryname")}        ${pref.getString("json_citystate")}");


                        if (_selectedDestination_1_1 == -1) {
                          if (pref.containsKey("json_citystate")) {
                            pref.remove("json_citystate");
                          }

                          Navigator.pop(context, null);
                        }

                        else if (pref.containsKey("filter_countryname") && pref.containsKey("filter_countryid")) {
                          if (!pref.containsKey("json_citystate")) {
                            Navigator.pop(context, "json_citystate");
                          }
                          else{
                            Navigator.pop(context, pref.containsKey("filter_countryname") ? pref.getString("filter_countryname") : "");
                          }
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
                  // pref.setInt("unselected_index_country", -1);
                  if (_selectedDestination_1_1 == -1) {
                    if (pref.containsKey("json_citystate")) {
                      pref.remove("json_citystate");
                    }
                  }

                  Navigator.pop(context ,"");
                  // Navigator.pop(context);
                },
              ),

              title: const Text('Country',
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
                searchBarUI(),

                Expanded(
                    child: Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(top: 10),

                      child: filtered_country.isNotEmpty && filtered_country!=null
                          ? ListView.builder(
                          itemCount: filtered_country.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              // margin: EdgeInsets.only(left: 10, right: 10),
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
                                            color: _selectedDestination_1_1 == filtered_country[index].id_val ? Color.fromRGBO(112, 197, 171, 1): Colors.transparent,
                                          ),

                                          child: ListTile(
                                            dense: true,
                                            minVerticalPadding: 0,
                                            contentPadding: EdgeInsets.only(left: 10), visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                                            title: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: new Text(
                                                  filtered_country[index].country,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                      'assets/fonts/lato.ttf',
                                                      color: _selectedDestination_1_1 == filtered_country[index].id_val ? Color.fromRGBO(255, 255, 255, 1): Color.fromRGBO(36, 33, 36, 1),
                                                      fontWeight:
                                                      FontWeight.w400)),
                                            ),

                                            selected: _selectedDestination_1_1 != filtered_country[index].id_val,

                                            trailing: Visibility(
                                              visible: _selectedDestination_1_1 == filtered_country[index].id_val,
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
                                              if (pref.containsKey("filter_countryname") && pref.containsKey("filter_countryid")) {
                                                pref.remove("filter_countryname");
                                                pref.remove("filter_countryid");
                                              }

                                              if (pref.containsKey("json_citystate")) {
                                                pref.remove("json_citystate");
                                              }

                                              pref.setString("filter_countryname", filtered_country[index].country);
                                              pref.setInt("filter_countryid", filtered_country[index].id_val);
                                              selectDestination(filtered_country[index].id_val);
                                              log("index_val  ${filtered_country[index]}   $index");
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
          controller: txtQuery,
          onChanged: filterSearchResults_country,
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

  void filterSearchResults_country(String query) {
    List<Country_data> dummySearchList = <Country_data>[];

    dummySearchList.addAll(filtered_country);
    filtered_country.clear();

    if (query.isNotEmpty) {
      List<Country_data> dummyListData = <Country_data>[];
      dummySearchList.forEach((item) {
        if (item.country.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        should_load = true;
        filtered_country.addAll(dummyListData);
        selectDestination(-1);
        print("index_val2 :-  ${filtered_country.length}  ${pref.getInt("unselected_index_country")!} ");
      });
      return;
    } else {
      setState(() {
        filtered_country.clear();
        filtered_country.addAll(all_country_session);
        should_load = true;
        selectDestination(pref.getInt("unselected_index_country")!);
        print("index_val3 :-  ${filtered_country.length}  ${pref.getInt("unselected_index_country")!} ");
      });
    }
  }

  void selectDestination(int index) {
    if (index != -1) {
      print("index_val7 :-  $_selectedDestination_1_1      $index ");
      if (_selectedDestination_1_1 == index) {
        setState(() {
          _selectedDestination_1_1 = -1;
          pref.setInt("unselected_index_country", _selectedDestination_1_1);
          print("index_val77 :-  ${pref.getInt("unselected_index_country")} ");
        });
      }
      else {
        setState(() {
          _selectedDestination_1_1 = index;
          pref.setInt("unselected_index_country", index);
          print("index_val7788 :-  ${pref.getInt("unselected_index_country")} ");
        });
      }
    }
    else{
      print("index_val777 :-  ${pref.getInt("unselected_index_country")} ");
      setState(() {
        _selectedDestination_1_1 = index;
        print("index_val77777 :-  $_selectedDestination_1_1 ");
      });
    }
  }
}

