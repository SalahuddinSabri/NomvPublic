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

class state_selector extends StatefulWidget {
  @override
  _state_selectorState createState() => _state_selectorState();
}

class State_data {
  final String State;

  State_data(this.State);

  factory State_data.fromJson(Map<String, dynamic> json) {
    return State_data(json['State']);
  }
}

class _state_selectorState extends State<state_selector> {
  bool should_state = false;
  List<State_data> state_select = [];
  List<String> tempList_state = [];
  List<String> filtered_state = [];
  TextEditingController txtQuery_state = new TextEditingController();
  late SharedPreferences pref;
  String _selectedDestination_state = "";


  @override
  void initState()  {
    super.initState();
    // pref = await shared_pref;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      pref = sp;

      get_state(context);
      // WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
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
        });
  }


  Future<List<State_data>?> get_state(BuildContext context) async {
    showLoaderDialog(context);

    if (pref.containsKey("unselected_index_state") && pref.containsKey("selected_statename")) {
      pref.remove("unselected_index_state");
      pref.setInt("unselected_index_state", -1);
      _selectedDestination_state= pref.getString("filter_statename")!;
    }
    else {
      pref.setInt("unselected_index_state", -1);
      _selectedDestination_state= "";
    }

    if (pref.containsKey("json_citystate")) {
      dynamic asdd = convert.jsonDecode(pref.getString("json_citystate")!);
      if (asdd.containsKey('success') == true) {
        var state_data_updated = asdd["states"] as List;
        if (state_data_updated.isNotEmpty) {
          filtered_state.clear();
          tempList_state.clear();
          state_select.clear();

          setState(() {
            state_select = state_data_updated.map<State_data>((json) => State_data.fromJson(json)).toList();

            if (state_select.isNotEmpty) {
              for (int k = 0; k < state_select.length; k++) {
                String filtered = state_select[k].State;
                filtered_state.add(filtered);
              }

              tempList_state.addAll(filtered_state);
              print("city_data43 :-  ${filtered_state.length}    ${tempList_state.length}");
            }
            should_state = true;
          });
          Navigator.pop(context);
        }
        else {
          Navigator.pop(context);
          setState(() {
            filtered_state.clear();
            should_state=true;
            print("filtered_state   ${filtered_state.length}");
          });

          return null;
        }
      }
    }
    else {
      Navigator.pop(context);
      setState(() {
        filtered_state.clear();
        should_state=true;
        print("filtered_state   ${filtered_state.length}");
      });

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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

                        if (_selectedDestination_state == "") {
                          Navigator.pop(context, null);
                        }

                        else if (pref.containsKey("filter_statename")) {
                          Navigator.pop(context, pref.containsKey("filter_statename") ? pref.getString("filter_statename") : null);
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
                  // pref.setInt("unselected_index_state", -1);
                  Navigator.pop(context, "");
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

            body: Column(
              children: [
                searchBarUI(),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(top: 10),

                    child: filtered_state.isNotEmpty && filtered_state!=null
                        ? ListView.builder(
                        itemCount: filtered_state.length,
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
                                          color: _selectedDestination_state.contains(filtered_state[index]) ? Color.fromRGBO(112, 197, 171, 1): Colors.transparent,
                                        ),

                                        child: ListTile(
                                          dense: true,
                                          minVerticalPadding: 0,
                                          contentPadding: EdgeInsets.only(left: 10), visualDensity: VisualDensity(horizontal: 0, vertical: 4),
                                          title: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: new Text(
                                                filtered_state[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                    'assets/fonts/lato.ttf',
                                                    color: _selectedDestination_state.contains(filtered_state[index]) ? Color.fromRGBO(255, 255, 255, 1): Color.fromRGBO(36, 33, 36, 1),
                                                    fontWeight:
                                                    FontWeight.w400)),
                                          ),

                                          selected: !_selectedDestination_state.contains(filtered_state[index]),

                                          trailing: Visibility(
                                            visible:
                                            _selectedDestination_state.contains(filtered_state[index]),
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
                                            if (pref.containsKey("filter_statename") && pref.containsKey("selected_statename")) {
                                              pref.remove("filter_statename");
                                              pref.remove("selected_statename");
                                            }
                                            pref.setString("filter_statename", filtered_state[index]);
                                            pref.setInt("selected_statename", index);
                                            selectDestination(filtered_state[index]);
                                            log("index_val" + filtered_state[index]);
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        : Visibility(
                      visible: should_state,
                      child: Center(child: Text(
                        "No state found...",
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
        // margin: EdgeInsets.all(15),

        // child: TextField(
        //   controller: nameController2,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(),
        //     labelText: 'Email Address',
        //   ),
        //   onChanged: (Text) {
        //     setState(() {});
        //   },
        // )
        child: TextFormField(
          controller: txtQuery_state,
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
        selectDestination("");
        print("city_data6 :-  ${filtered_state.length}");
      });
      return;
    } else {
      setState(() {
        filtered_state.clear();
        filtered_state.addAll(tempList_state);
        should_state = true;
        selectDestination(pref.getString("filter_statename")!);
        print("city_data7 :-  ${filtered_state.length}");
      });
    }
  }




  void selectDestination(String index) {
    if (index.isNotEmpty) {
      print("index_val7 :-  $_selectedDestination_state      $index ");
      if (_selectedDestination_state == index) {
        setState(() {
          _selectedDestination_state = "";
          pref.setString("filter_statename", _selectedDestination_state);
          print("index_val77 :-  ${pref.getString("filter_statename")} ");
        });
      }
      else {
        setState(() {
          _selectedDestination_state = index;
          pref.setString("filter_statename", index);
          print("index_val7788 :-  ${pref.getString("filter_statename")} ");
        });
      }
    }
    else{
      print("index_val777 :-  ${pref.getString("filter_statename")} ");
      setState(() {
        _selectedDestination_state = index;
        print("index_val77777 :-  $_selectedDestination_state ");
      });
    }
  }
}
