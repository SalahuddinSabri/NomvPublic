import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/const.dart';
import 'aboutus/filter_screen.dart';

class country_selector extends StatefulWidget {
  @override
  _country_selectorState createState() => _country_selectorState();
}

class _country_selectorState extends State<country_selector> {
  String countryValue = "";
  TextEditingController txtQuery = new TextEditingController();
  int _selectedDestination_1_1 = -1;

  bool should_load = false;
  List<all_country> all_country_session = [];
  List<String> tempList = [];
  List<String> filtered_country = [];

  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }

  void onLayoutDone(Duration timeStamp) async {
    pref = await shared_pref;
    get_all_countries(context);
  }

  Future<List<all_country>?> get_all_countries(BuildContext context) async {
    if (pref.containsKey("unselected_index_country")) {
      pref.remove("unselected_index_country");
      pref.setInt("unselected_index_country", -1);
    } else {
      pref.setInt("unselected_index_country", -1);
    }

    var my_data =
        json.decode(await rootBundle.loadString('assets/data/countries.json'));
    if (my_data.containsKey('msg')) {
      var all_country_data = my_data["data"] as List;

      if (all_country_data.isNotEmpty) {
        setState(() {
          all_country_session = all_country_data
              .map<all_country>((json) => all_country.fromJson(json))
              .toList();

          if (all_country_session.isNotEmpty) {
            for (int k = 0; k < all_country_session.length; k++) {
              String filtered= all_country_session[k].name;
              filtered_country.add(filtered);

            }

            tempList.addAll(filtered_country);
            print("city_data43 :-  ${filtered_country.length}    ${tempList.length}");

          }
          should_load = true;
        });

        /*for (int ks = 0; ks < filtered_country.length; ks++) {
          print("city_data44 :-  ${filtered_country[ks]}");
        }*/
      } else {
        return null;
      }
    }
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
            // onWillPop: () async => true,
            onWillPop: () async {
              pref.setInt("unselected_index_country", -1);
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
                          print(
                              "getvalue   ${pref.getInt("unselected_index_country")}");

                          if (pref.getInt("unselected_index_country") != -1) {
                            if (pref.containsKey("filter_countryname")) {
                              if (pref
                                  .getString("filter_countryname")!
                                  .isNotEmpty) {
                                print(
                                    "country_selectedname ${pref.getString("filter_countryname")}");

                                pref.setInt("unselected_index_country", -1);

                                Navigator.pop(
                                    context, pref.getString("filter_countryname"));
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Select Country..!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff586BC6),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Select Country..!!",
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
                    pref.setInt("unselected_index_country", -1);
                    Navigator.pop(context, null);
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
                          itemCount: filtered_country.length,
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
                                              filtered_country[index],
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
                                            _selectedDestination_1_1 == index
                                                ? Colors.blue
                                                : Colors.transparent,

                                        trailing: Visibility(
                                          visible:
                                              _selectedDestination_1_1 == index,
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
                                          SharedPreferences pref =
                                              await shared_pref;
                                          if (pref.containsKey(
                                              "filter_countryname")) {
                                            pref.remove("filter_countryname");
                                          }
                                          pref.setString("filter_countryname", filtered_country[index]);
                                          selectDestination(index);
                                          log("index_val" + filtered_country[index]);
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff714CBF))),),
      );
    }
  }

  Widget searchBarUI() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: txtQuery,
        onChanged: filterSearchResults_country,
        decoration: InputDecoration(
          hintText: "Search",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
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

  void filterSearchResults_country(String query) {
    List<String> dummySearchList = <String>[];

    // tempList.addAll(filtered_country);
    dummySearchList.addAll(filtered_country);

    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filtered_country.clear();
        should_load = true;
        filtered_country.addAll(dummyListData);
        print("city_data6 :-  ${filtered_country.length}");
      });
      return;
    } else {
      setState(() {
        filtered_country.clear();
        filtered_country.addAll(tempList);
        should_load = true;
        print("city_data7 :-  ${filtered_country.length}");
      });
    }
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination_1_1 = index;
      pref.setInt("unselected_index_country", index);
    });
  }

// Widget searchBarUI() {
//   return Container(
//     margin: EdgeInsets.only(left: 5, right: 5),
//     padding: EdgeInsets.only(bottom: 10.0),
//     child: TextFormField(
//       controller: txtQuery,
//       // onChanged: _filterDogList,
//       decoration: InputDecoration(
//         hintText: "Search",
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
//         focusedBorder:
//             OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
//         prefixIcon: Icon(Icons.search),
//         suffixIcon: IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             txtQuery.text = '';
//             // _filterDogList(txtQuery.text);
//           },
//         ),
//       ),
//     ),
//   );
// }
}

/*
class LoginPage extends StatefulWidget {
  List<all_country> mList_country = [];
  SharedPreferences? pref;

  LoginPage(List<all_country> mList, SharedPreferences pref) {
    this.mList_country = mList;
    this.pref = pref;
    print("the country is :- ${mList_country.length}");
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}
*/

/*class _LoginPageState extends State<LoginPage> {
  int? _selectedDestination_1;

  @override
  Widget build(BuildContext context) {
    if (widget.mList_country.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.mList_country.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 80,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          child: ListTile(
                        dense: true,
                        minVerticalPadding: 0,
                        contentPadding: EdgeInsets.only(left: 5),
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: 4),
                        title: Container(
                          // margin: EdgeInsets.only(top: 15),
                          child: new Text(widget.mList_country[index].name,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'assets/fonts/lato.ttf',
                                  color: Color.fromRGBO(36, 33, 36, 1),
                                  fontWeight: FontWeight.normal)),
                        ),

                        // selected: _selectedDestination_1 == 0,
                        tileColor: _selectedDestination_1 == index
                            ? Colors.blue
                            : Colors.transparent,

                        trailing: Visibility(
                          visible: _selectedDestination_1 == index,
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            child: Image.asset(
                              "assets/images/selected_img.png",
                              height: 50.0,
                              width: 50.0,
                            ),
                          ),

                          // child: Container(
                          //   margin: EdgeInsets.only(top: 15),
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //     //or 15.0
                          //
                          //   ),
                          // ),
                        ),

                        onTap: () async {
                          SharedPreferences pref = await shared_pref;
                          if (pref.containsKey("filter_countryname")) {
                            pref.remove("filter_countryname");
                          }
                          pref.setString("filter_countryname",
                              widget.mList_country[index].name);
                          selectDestination(index);
                          log("index_val" + widget.mList_country[index].name);
                        },
                      )),
                    ),
                  ],
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
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      );
    }
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination_1 = index;
      widget.pref?.setInt("unselected_index_country", index);
    });
  }
}*/

class all_country {
  final String name;
  final String capital;

  all_country(this.name, this.capital);

  factory all_country.fromJson(Map<String, dynamic> json) {
    return all_country(
      json['name'],
      json['capital'],
    );
  }
}
