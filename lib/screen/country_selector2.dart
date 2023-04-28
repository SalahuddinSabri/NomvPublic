import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

class country_selector extends StatefulWidget {
  @override
  _country_selectorState createState() => _country_selectorState();
}

class _country_selectorState extends State<country_selector> {
  String countryValue = "";

  // String? stateValue = "";
  // String? cityValue = "";
  // String address = "";
  bool should_load = false;
  List<all_country> all_country_session = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<all_country>?> get_all_countries(BuildContext context) async {
    var my_data = json.decode(await getJson());
    if (my_data.containsKey('msg')) {
      var all_country_data = my_data["data"] as List;

      if (all_country_data.isNotEmpty) {
        setState(() {
          all_country_session = all_country_data.map<all_country>((json) => all_country.fromJson(json)).toList();
          should_load = true;
        });
        print("the message is :-  ${all_country_session.length}");
      }
    }
  }

  Future<String> getJson() {
    return rootBundle.loadString('countries.json');
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
            onWillPop: () async => true,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: new AppBar(
                centerTitle: true,
                elevation: 0,
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 15.0),
                    child: Center(
                      child: Text("Done",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Karla',
                              color: Color.fromRGBO(133, 225, 137, 1),
                              fontWeight: FontWeight.bold)),
                    ),
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
                    Navigator.pop(context);
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
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: _buildList(all_country_session),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    else {
      return Center(
        child: Container(
            width: 40.0,
            height: 40.0,
            child: const CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
      );
    }
  }
}


class _buildList extends StatelessWidget {
  List<all_country> mList_country = [];

  _buildList(List<all_country> mList) {
    this.mList_country = mList;
    print("the country is :- ${mList_country.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (mList_country.isNotEmpty) {
      return ListView.builder(
          itemCount: mList_country.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              height: 120,
              child: Card(
                elevation: 10.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                        bottomLeft: Radius.circular(7))),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        Color.fromRGBO(62, 169, 189, 0.15),
                        Color.fromRGBO(88, 107, 198, 0.1),
                        // Color.fromRGBO(130, 52, 243, 1),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(child: Upcoming_List(mList_country[index], context)),
                      ),
                    ],
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
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      );
    }
  }

  Widget Upcoming_List(all_country data, BuildContext context) {
    return new ListTile(
      title: Container(
        margin: EdgeInsets.only(top: 15),
        child: new Text(data.name,
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Karla',
                color: Color(0xff36489C),
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}





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
