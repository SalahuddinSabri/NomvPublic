import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/const.dart';
import 'aboutus/filter_screen.dart';

class state_selector extends StatefulWidget {
  @override
  _state_selectorState createState() => _state_selectorState();
}

class _state_selectorState extends State<state_selector> {
  bool should_state = false;
  List<all_state> state_select = [];
  List<String> tempList_state = [];
  List<String> filtered_state = [];
  TextEditingController txtQuery_state = new TextEditingController();
  late SharedPreferences pref;
  int _selectedDestination_state = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }

  void onLayoutDone(Duration timeStamp) async {
    pref = await shared_pref;
    get_state(context);
  }

  Future<List<all_state>?> get_state(BuildContext context) async {
    final String bookmark_url =
        'https://countriesnow.space/api/v0.1/countries/cities';

    if (pref.containsKey("unselected_index_state")) {
      pref.remove("unselected_index_state");
      pref.setInt("unselected_index_state", -1);
    } else {
      pref.setInt("unselected_index_state", -1);
    }

    /* Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = utf8.encode(jsonEncode({
      "country": "Afghanistan",
    }));

    final response = await post(
      Uri.parse(bookmark_url),
      headers: headers,
      body: msg,
    );

    log("city_data6      ${response.statusCode}");*/

    var my_data = json.decode(await rootBundle.loadString('assets/data/states.json'));

    if (my_data.containsKey('msg')) {
      var my_data2 = my_data['data'];
      var all_country_data = my_data2["states"] as List;

      log("city_data3     $all_country_data");
      if (all_country_data.isNotEmpty) {
        setState(() {
          /* state_select = all_country_data.map<all_state>((json) => all_state.fromJson(json)).toList();
          should_state = true;*/
          state_select = all_country_data
              .map<all_state>((json) => all_state.fromJson(json))
              .toList();

          if (state_select.isNotEmpty) {
            for (int k = 0; k < state_select.length; k++) {
              String filtered = state_select[k].name;
              filtered_state.add(filtered);
            }

            if (filtered_state.isNotEmpty) {
              tempList_state.addAll(filtered_state);
              print("city_data43 :-  ${filtered_state.length}    ${tempList_state.length}");
            }
          }
          should_state = true;
        });
        print("the message is :-  ${state_select.length}");
      } else {
        return null;
      }
    } else {
      Fluttertoast.showToast(
          msg: "Failed to bookmark , try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff586BC6),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    if (should_state) {
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
              pref.setInt("unselected_index_state", -1);
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
                          print("getvalue   ${pref.getInt("unselected_index_state")}");

                          if (pref.getInt("unselected_index_state") != -1) {
                            if (pref.containsKey("filter_statename")) {
                              if (pref
                                  .getString("filter_statename")!
                                  .isNotEmpty) {
                                print(
                                    "country_selectedname ${pref.getString("filter_statename")}");

                                pref.setInt("unselected_index_state", -1);

                                Navigator.pop(context, pref.getString("filter_statename"));
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Select State..!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color(0xff586BC6),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Select State..!!",
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
                    pref.setInt("unselected_index_state", -1);
                    Navigator.pop(context, null);
                  },
                ),
                title: const Text('State',
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
                    searchBarUI(),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: ListView.builder(
                            itemCount: filtered_state.length,
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
                                            child: new Text(
                                                filtered_state[index],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily:
                                                        'assets/fonts/lato.ttf',
                                                    color: Color.fromRGBO(
                                                        36, 33, 36, 1),
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),

                                          // selected: _selectedDestination == 0,
                                          tileColor:
                                              _selectedDestination_state ==
                                                      index
                                                  ? Colors.blue
                                                  : Colors.transparent,

                                          trailing: Visibility(
                                            visible:
                                                _selectedDestination_state ==
                                                    index,
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
                                            if (pref.containsKey("filter_statename")) {
                                              pref.remove("filter_statename");
                                            }
                                            pref.setString("filter_statename", filtered_state[index]);
                                            selectDestination(index);
                                            log("index_val" + filtered_state[index]);
                                          },
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
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
        controller: txtQuery_state,
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
    dummySearchList.addAll(filtered_state);

    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filtered_state.clear();
        should_state = true;
        filtered_state.addAll(dummyListData);
        print("city_data6 :-  ${filtered_state.length}");
      });
      return;
    } else {
      setState(() {
        filtered_state.clear();
        filtered_state.addAll(tempList_state);
        should_state = true;
        print("city_data7 :-  ${filtered_state.length}");
      });
    }
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination_state = index;
      pref.setInt("unselected_index_state", index);
    });
  }
}


class all_state {
  final String name;

  all_state(this.name);

  factory all_state.fromJson(Map<String, dynamic> json) {
    return all_state(
      json['name'],
    );
  }
}
