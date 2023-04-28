import 'dart:async';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Resources_screen/Resource_infographics.dart';
import 'package:path_provider/path_provider.dart';
import '../Home/home_data.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import '../Utils/const.dart';
import '../Utils/pdf_api.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Utils/pdf_viewer_page.dart';

class Resources_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new Resources_State();
  }
}

class Resources {
  final String resource_name;
  final String resource_url, created_at, updated_at;

  Resources(this.resource_name, this.resource_url, this.created_at, this.updated_at);

  factory Resources.fromJson(Map<String, dynamic> json) {
    return Resources(json['resource_name'], json['resource_url'], json['created_at'] , json['updated_at']);
  }
}

class Resources_State extends State<Resources_Screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onLayoutDone);
  }

  void onLayoutDone(Duration timeStamp) async {}

  Future<List<Resources>?> resources_fetchdata() async {
    bool isOnline = await globals.hasNetwork();
    if (isOnline) {
      final uri_val = await http.get(
        Uri.parse("${base_url}resources"),
        headers: <String, String>{"Content-Type": "application/json"},
      );

      print("all_resources2     ${base_url}resources     ${uri_val.statusCode}");

      if (uri_val.statusCode == 200) {
        dynamic asdd = convert.jsonDecode(uri_val.body);

        if (asdd.containsKey('success') == true) {
          var sponsers_array = asdd["resources"] as List;
          if (sponsers_array.isNotEmpty) {
            return sponsers_array.map<Resources>((json) => Resources.fromJson(json)).toList();
          } else {
            return null;
          }
        }
      }
    } else {
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


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/resource_back.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              leading: IconButton(
                icon: Image.asset(
                  'assets/images/menu.png',
                  height: 15,
                  width: 15,
                  color: Colors.white,
                  fit: BoxFit.cover,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text('Resources',
                  style: TextStyle(
                      fontFamily: 'Karla',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
            ),


            body: Align(
              alignment: Alignment.center,
              child: FutureBuilder(
                  future: resources_fetchdata(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: Text(
                              "No Data Found...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.blue,
                                fontFamily: 'RobotoMono',
                              ),
                            ),
                          ),
                        );
                      } else {
                        // print("all_resources     ${snapshot.data.resource_name}     ${snapshot.data.resource_url}");
                        return Container(
                          margin: EdgeInsets.only(top: 15),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                  margin: EdgeInsets.only(top: 5,bottom: 5, left: 10, right: 10),
                                  height: 90,
                                  child: Card(
                                    color: Color(0xfff3eaf2),
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/resource_background.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(child: ResourcesListTile(snapshot.data[index], context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    } else {
                      return Center(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          child: const CircularProgressIndicator(
                              backgroundColor: Color(0xffd7b563),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff714CBF))),
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }
}

class ResourcesListTile extends ListTile {
  ResourcesListTile(data, BuildContext context)
      : super(
    leading: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 250,
              child: Text(
                data.resource_name.isEmpty ? "To be available soon" : data
                    .resource_name,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(140, 54, 156, 1),
                  fontFamily: 'Karla',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    dense: true,

    onTap: () async {
      if (!data.resource_name.toString().contains("NOMV Infographic (available in multiple languages*)")) {
        if (Platform.isAndroid) {
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt > 29) {
            if (await Permission.manageExternalStorage.isGranted) {
              Fluttertoast.showToast(
                  msg: "Downloading file... please wait",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xff586BC6),
                  textColor: Colors.white,
                  fontSize: 16.0);
              showLoaderDialog(context);

              final file = await PDFApi.loadNetwork(data.resource_url ==
                  null
                  ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
                  : data.resource_url);
              if (await file.exists()) {
                Navigator.pop(context);

                Fluttertoast.showToast(
                    msg: "Downloaded successfully...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xff586BC6),
                    textColor: Colors.white,
                    fontSize: 16.0);

                Timer(Duration(milliseconds: 500),
                        () => openPDF(context, file));
              }
            }
          } else {
            if (await Permission.storage.isGranted) {
              Fluttertoast.showToast(
                  msg: "Downloading file... please wait",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xff586BC6),
                  textColor: Colors.white,
                  fontSize: 16.0);
              showLoaderDialog(context);

              final file = await PDFApi.loadNetwork(data.resource_url ==
                  null
                  ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
                  : data.resource_url);
              if (await file.exists()) {
                Navigator.pop(context);

                Fluttertoast.showToast(
                    msg: "Downloaded successfully...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xff586BC6),
                    textColor: Colors.white,
                    fontSize: 16.0);

                Timer(Duration(milliseconds: 500),
                        () => openPDF(context, file));
              }
            }
          }
        }
        else if (Platform.isIOS) {
          // if (await Permission.photosAddOnly.isGranted && await Permission.photos.isGranted) {
          Fluttertoast.showToast(
              msg: "Downloading file... please wait",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff586BC6),
              textColor: Colors.white,
              fontSize: 16.0);
          showLoaderDialog(context);

          // iOS-specific code
          createFileOfPdfUrl(data.resource_url == null
              ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
              : data.resource_url)
              .then((f) async {
            if (await f.exists()) {
              Navigator.pop(context);

              Fluttertoast.showToast(
                  msg: "Downloaded successfully...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xff586BC6),
                  textColor: Colors.white,
                  fontSize: 16.0);

              Timer(
                  Duration(milliseconds: 500), () => openPDF(context, f));
            }
          });

          /*if (await Permission.photosAddOnly.isGranted && await Permission.photos.isGranted) {
                    Fluttertoast.showToast(
                        msg: "Downloading file... please wait",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xff586BC6),
                        textColor: Colors.white,
                        fontSize: 16.0);
                    showLoaderDialog(context);

                    // iOS-specific code
                    createFileOfPdfUrl(data.resource_url == null
                            ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
                            : data.resource_url)
                        .then((f) async {
                      if (await f.exists()) {
                        Navigator.pop(context);

                        Fluttertoast.showToast(
                            msg: "Downloaded successfully...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xff586BC6),
                            textColor: Colors.white,
                            fontSize: 16.0);

                        Timer(Duration(milliseconds: 500),
                            () => openPDF(context, f));
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Permission Required to proceed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xff586BC6),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }*/
        }
      }
      else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Resources_infographics(
                    heading_name: data.resource_name.isEmpty
                        ? "To be available soon"
                        : "NOMV Infographic")));
      }
    },
  );
}


Future<File> createFileOfPdfUrl(String pdf_url) async {
  Completer<File> completer = Completer();

  try {
    final url = pdf_url;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    print("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}

void openPDF(BuildContext context, File file) => Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
);

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
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xff714CBF)))),
        );
      });
}




// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:nomv/screen/Resources_screen/Resource.dart';
// import 'package:path/path.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
//
// class PDFViewerPage extends StatefulWidget {
//    String resource_url;
//
//   PDFViewerPage({required this.resource_url});
//
//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }
//
// class _PDFViewerPageState extends State<PDFViewerPage> {
//   late PDFViewController controller;
//   int pages = 0;
//   int indexPage = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final name = basename(widget.resource_url);
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/resource_back.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//
//         leading: Container(
//           margin: EdgeInsets.only(top: 2),
//           child: IconButton(
//             icon: Image.asset(
//               'assets/images/back_menu.png',
//               height: 13,
//               width: 13,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Resources_Screen()), (route) => false);
//             },
//           ),
//         ),
//
//         title:  Text(name,
//             style: TextStyle(
//                 fontFamily: 'Karla',
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//       ),
//
//         body: Container(
//             child: PDF().cachedFromUrl(
//               widget.resource_url,
//               maxAgeCacheObject:Duration(days: 30), //duration of cache
//
//               placeholder: (progress) => Center(
//                 child: Container(
//                   child: CircularPercentIndicator(
//                     radius: 60.0,
//                     animation: true,
//                     animationDuration: 1200,
//                     lineWidth: 15.0,
//
//                     center: new Text(
//                       '${progress.toInt()} %',
//                       style: new TextStyle(
//                           color: Color.fromRGBO(195, 174, 121, 1),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Lato'),
//                     ),
//                     circularStrokeCap: CircularStrokeCap.butt,
//                     backgroundColor:  Color(0xffd7b563),
//                     progressColor: Colors.white,
//                   ),
//                 ),
//               ),
//                 errorWidget: (error) => Center(
//                     child: Text("Failed to load pdf due to no internet",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.blue,
//                           fontFamily: 'Karla',
//                           // body: PDFView(
//                         )
//                     )
//                 )
//             )
//
//         )
//     );
//   }
// }
