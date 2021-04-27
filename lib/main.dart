import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin<MyHomePage> {

  WebViewController _controller;
  final Completer<WebViewController> _completerController = Completer<WebViewController>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.initState();
    /*if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();*/
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => _goBack(context),
          child: WebView(
            onWebViewCreated: (WebViewController webViewController) {
              _completerController.future.then((value) => _controller = value);
              _completerController.complete(webViewController);
            },
            initialUrl: 'http://192.168.0.125:8080/council/demo/index.do',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goBack(context);
        },
        child: Icon(Icons.arrow_back_ios_outlined),
        backgroundColor: Colors.blue,
      ),
    );
  }


  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }


}