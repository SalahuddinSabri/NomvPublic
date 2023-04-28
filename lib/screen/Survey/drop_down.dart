import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dropdown_button2.dart';

class DropDown extends StatefulWidget {
  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedValue;
  int myVariable = 0;

  int yourLocalVariable = 0;
  var _result;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Stack(children: <Widget>[
      Image.asset(
        "assets/images/background_app.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        // extendBodyBehindAppBar: true,
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 0,
          centerTitle: true,
          title: const Text('Survey',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Karla',
              )),
          backgroundColor: Colors.transparent,
          //2A3351
          automaticallyImplyLeading: true,
        ),

        body: Align(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/images/background_app.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 20),
                    child: Text(
                      'Which Presenter would you like to rate ?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Karla',
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),

                        focusedBorder: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),

                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(35),),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Your Presenter',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Karla',
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      items: genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontFamily: 'Karla',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select gender.';
                        }
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0" + myVariable.toString() + "/03",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Karla',
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              indent: 10.0,
                              endIndent: 20.0,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),





                  //please rate the content..!! (1)
                  Column(
                    children: [
                      Container(child: Container(
                        margin: EdgeInsets.only(left: 13, right: 13),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(40, 52, 85, 0.8).withOpacity(1),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text(
                          'Please rate the presentation and content',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Karla',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height / 6,
                        width: double.infinity,
                        // decoration: BoxDecoration(color: Color.fromRGBO(34, 41, 72, 0.9)),
                        padding: EdgeInsets.only(left: 0, top: 0.0, right: 0),
                        margin: EdgeInsets.only(left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.white, spreadRadius: 2),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(
                              padding:
                              EdgeInsets.only(left: 0, top: 0.0, right: 0),
                              margin: EdgeInsets.only(
                                  left: 15.0,
                                  top: 0.0,
                                  right: 15.0,
                                  bottom: 0.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*Rate from 1 to 5',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontFamily: 'Karla',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: NumericStepButton(
                                maxValue: 20,
                                onChanged: (value) {
                                  yourLocalVariable = value;
                                },
                              ),
                            ),
                            Container(
                              padding:
                              EdgeInsets.only(left: 0, top: 10.0, right: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Low',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        letterSpacing: 0.5,
                                        fontFamily: 'Karla',
                                      )),
                                  Text('High',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: 'Karla',
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 20.0),

                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0" + myVariable.toString() + "/03",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Karla',
                              color: Colors.white,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              indent: 10.0,
                              endIndent: 20.0,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),


                  //recommand (2)
                  Column(
                    children: [
                      Container(
                          child: Container(
                        margin: EdgeInsets.only(left: 13, right: 13),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(40, 52, 85, 0.8).withOpacity(1),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                        child: Text(
                          'Please rate the presenter(s) and his/her ability to present',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Karla',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height / 6,
                        width: double.infinity,
                        // decoration: BoxDecoration(color: Color.fromRGBO(34, 41, 72, 0.9)),
                        padding: EdgeInsets.only(left: 0, top: 0.0, right: 0),
                        margin: EdgeInsets.only(
                            left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.white, spreadRadius: 2),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(
                              padding:
                              EdgeInsets.only(left: 0, top: 0.0, right: 0),
                              margin: EdgeInsets.only(
                                  left: 15.0,
                                  top: 0.0,
                                  right: 15.0,
                                  bottom: 0.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*Rate from 1 to 5',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontFamily: 'Karla',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: NumericStepButton(
                                maxValue: 20,
                                onChanged: (value) {
                                  yourLocalVariable = value;
                                },
                              ),
                            ),
                            Container(
                              padding:
                              EdgeInsets.only(left: 0, top: 10.0, right: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Low',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        letterSpacing: 0.5,
                                        fontFamily: 'Karla',
                                      )),
                                  Text('High',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: 'Karla',
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0" + myVariable.toString() + "/03",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Karla',
                              color: Colors.white,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              indent: 10.0,
                              endIndent: 20.0,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),



                  //recommand (3)
                  Column(
                    children: [
                      Container(
                          child: Container(
                            margin: EdgeInsets.only(left: 13, right: 13),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(40, 52, 85, 0.8).withOpacity(1),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))),
                            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                            child: Text(
                              'Would you recommand this presentation for another AGXPE event?',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'Karla',
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          )
                      ),

                      Container(
                        alignment: Alignment.centerLeft,

                        width: double.infinity,
                        // decoration: BoxDecoration(color: Color.fromRGBO(34, 41, 72, 0.9)),
                        padding: EdgeInsets.only(left: 0, top: 0.0, right: 0),
                        margin: EdgeInsets.only(left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.white, spreadRadius: 2),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RadioListTile(
                                title: Align(
                                  child: Text('Yes',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Karla',
                                      )),
                                  alignment: Alignment(-1.1, 0),
                                ),
                                value: 4,
                                groupValue: _result,
                                contentPadding: EdgeInsets.only(
                                  // Add this
                                    left: 15,
                                    right: 0,
                                    bottom: 0,
                                    top: 0),
                                dense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _result = value;
                                  });
                                }),
                            RadioListTile(
                              // title: const Text('No'),
                                title: Align(
                                  child: Text('No',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Karla',
                                      )),
                                  alignment: Alignment(-1.1, 0),
                                ),
                                value: 5.4,
                                groupValue: _result,
                                contentPadding: EdgeInsets.only(
                                  // Add this
                                    left: 15,
                                    right: 0,
                                    bottom: 0,
                                    top: 0),
                                dense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _result = value;
                                  });
                                }),
                          ],
                        ),
                      )

                    ],
                  ),

                  SizedBox(height: 20.0),



































                  /*//please rate the content..!!
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height / 4,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(color: Colors.white, spreadRadius: 2.5),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15, bottom: 0, right: 0, top: 20),
                              child: Text(
                                'Please rate the presentation and content',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Karla',
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            )),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.only(left: 0, top: 0.0, right: 0),
                          margin: EdgeInsets.only(
                              left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '*Rate from 1 to 5',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontFamily: 'Karla',
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: NumericStepButton(
                            maxValue: 20,
                            onChanged: (value) {
                              yourLocalVariable = value;
                            },
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 0, top: 10.0, right: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('Low',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    letterSpacing: 0.5,
                                    fontFamily: 'Karla',
                                  )),
                              Text('High',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontFamily: 'Karla',
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.0),

                  //ability to present
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0" + myVariable.toString() + "/03",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Karla',
                              color: Colors.white,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              indent: 10.0,
                              endIndent: 20.0,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),

                  //recommand
                  Column(
                    children: [
                      Container(child: Container(
                        margin: EdgeInsets.only(left: 13, right: 13),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(43, 43, 44, 1.0).withOpacity(1),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text(
                          'Please rate the presenter(s) and his/her ability to present',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Karla',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height / 4,
                        width: double.infinity,
                        // decoration: BoxDecoration(color: Color.fromRGBO(34, 41, 72, 0.9)),
                        padding: EdgeInsets.only(left: 0, top: 0.0, right: 0),
                        margin: EdgeInsets.only(
                            left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.white, spreadRadius: 2),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15),
                            Container(
                              padding:
                                  EdgeInsets.only(left: 0, top: 0.0, right: 0),
                              margin: EdgeInsets.only(
                                  left: 15.0,
                                  top: 0.0,
                                  right: 15.0,
                                  bottom: 0.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '*Rate from 1 to 5',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontFamily: 'Karla',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: NumericStepButton(
                                maxValue: 20,
                                onChanged: (value) {
                                  yourLocalVariable = value;
                                },
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(left: 0, top: 10.0, right: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('Low',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        letterSpacing: 0.5,
                                        fontFamily: 'Karla',
                                      )),
                                  Text('High',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: 'Karla',
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0" + myVariable.toString() + "/03",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Karla',
                              color: Colors.white,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Divider(
                              indent: 10.0,
                              endIndent: 20.0,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height / 3.8,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 15.0, top: 0.0, right: 15.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.white, spreadRadius: 2),
                      ],
                    ),


                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15,
                                  bottom: 0,
                                  right: 0,
                                  top: 20), //apply padding to some sides only
                              child: Text(
                                'Would you recommand this presentation for another AGXPE event?',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: 'Karla',
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            )),

                        // Container(
                        //   alignment: Alignment.center,
                        //   height: 60,
                        //   color: Color.fromRGBO(34, 41, 72, 0.9),
                        //   padding: EdgeInsets.only(left: 10),
                        //   child: Text(
                        //     'Would you recommand this presentation for another AGXPE event?',
                        //     style: TextStyle(
                        //       fontSize: 15.0,
                        //       fontFamily: 'Karla',
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 15),
                        Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RadioListTile(
                                title: Align(
                                  child: Text('Yes',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Karla',
                                      )),
                                  alignment: Alignment(-1.1, 0),
                                ),
                                value: 4,
                                groupValue: _result,
                                contentPadding: EdgeInsets.only(
                                    // Add this
                                    left: 15,
                                    right: 0,
                                    bottom: 0,
                                    top: 0),
                                dense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _result = value;
                                  });
                                }),
                            RadioListTile(
                                // title: const Text('No'),
                                title: Align(
                                  child: Text('No',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Karla',
                                      )),
                                  alignment: Alignment(-1.1, 0),
                                ),
                                value: 5.4,
                                groupValue: _result,
                                contentPadding: EdgeInsets.only(
                                    // Add this
                                    left: 15,
                                    right: 0,
                                    bottom: 0,
                                    top: 0),
                                dense: true,
                                onChanged: (value) {
                                  setState(() {
                                    _result = value;
                                  });
                                }),
                          ],
                        )),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),*/



                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      // padding: EdgeInsets.only(left: 10, right: 20, top: 0, bottom: 20),

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(74, 95, 169, 1).withOpacity(0.4),
                            Color.fromRGBO(32, 49, 112, 1).withOpacity(0.2),
                          ],
                        ),
                      ),

                      margin: EdgeInsets.only(top: 5, bottom: 20, left: 30, right: 30),

                      child: Center(
                          child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Karla',
                            color: Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;

  final ValueChanged<int> onChanged;

  NumericStepButton(
      {this.minValue = 0, this.maxValue = 10, required this.onChanged})
      : super();

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, top: 0.0, right: 15.0, bottom: 0.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(34, 41, 72, 0.9),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter > widget.minValue) {
                  counter--;
                }
                widget.onChanged(counter);
              });
            },
          ),
          Text(
            '$counter',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Karla',
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),

            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter < widget.maxValue) {
                  counter++;
                }
                widget.onChanged(counter);
              });
            },
          ),
        ],
      ),
    );
  }
}
