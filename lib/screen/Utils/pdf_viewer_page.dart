import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomv/screen/Resources_screen/Resource.dart';
import 'package:nomv/screen/Utils/pdf_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewerPage extends StatefulWidget {
  String resource_url;

  PDFViewerPage({required this.resource_url});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.resource_url);

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/resource_back.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          leading: Container(
            margin: EdgeInsets.only(top: 2),
            child: IconButton(
              icon: Image.asset(
                'assets/images/back_menu.png',
                height: 13,
                width: 13,
              ),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Resources_Screen()), (route) => false);
              },
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    maxLines: 1, // TRY THIS
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Image.asset(
                  'assets/images/download_pdf.png',
                  color: Colors.white,
                  height: 20,
                  width: 20,
                ),
                onPressed: () async {
                  showLoaderDialog(context);

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

                        final file = await PDFApi.loadNetwork(widget
                            .resource_url ==
                            null ||
                            widget.resource_url.isEmpty
                            ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
                            : widget.resource_url);
                        if (await file.exists()) {
                          print('file_option    $file');
                          Navigator.pop(context);

                          Fluttertoast.showToast(
                              msg: "Downloaded successfully...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color(0xff586BC6),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    }
                    else {
                      if (await Permission.storage.isGranted) {
                        Fluttertoast.showToast(
                            msg: "Downloading file... please wait",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xff586BC6),
                            textColor: Colors.white,
                            fontSize: 16.0);

                        final file = await PDFApi.loadNetwork(widget
                            .resource_url ==
                            null ||
                            widget.resource_url.isEmpty
                            ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
                            : widget.resource_url);
                        if (await file.exists()) {
                          print('file_option2    $file');

                          Navigator.pop(context);

                          Fluttertoast.showToast(
                              msg: "Downloaded successfully...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Color(0xff586BC6),
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    }
                  }

                  else if (Platform.isIOS) {
                    Fluttertoast.showToast(
                        msg: "Downloading file... please wait",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xff586BC6),
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // iOS-specific code
                    createFileOfPdfUrl(widget.resource_url == null ||
                        widget.resource_url.isEmpty
                        ? "https://www.learningcontainer.com/wp-content/uploads/2019/09/sample-pdf-with-images.pdf"
                        : widget.resource_url)
                        .then((f) async {
                      if (await f.exists()) {
                        Navigator.pop(context);

                        print('file_option3    $f');

                        Fluttertoast.showToast(
                            msg: "Downloaded successfully...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xff586BC6),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  }
                })
          ],
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: PDF(
            autoSpacing: false,
            pageFling: true,
          ).cachedFromUrl(widget.resource_url,
              maxAgeCacheObject: Duration(days: 30), //duration of cache

              placeholder: (progress) => Center(
                child: Container(
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 15.0,
                    center: new Text(
                      '${progress.toInt()} %',
                      style: new TextStyle(
                          color: Color.fromRGBO(195, 174, 121, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Lato'),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Color(0xffd7b563),
                    progressColor: Colors.white,
                  ),
                ),
              ),
              errorWidget: (error) => Center(
                  child: Text("Failed to load pdf due to no internet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                        fontFamily: 'Karla',
                        // body: PDFView(
                      )))),
        ));
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
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xff714CBF)))),
          );
        });
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
      print("ios_download_path   ${dir.path}/$filename");
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      print("ios_download_path   ${file.path}");

      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
