import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:getdefaultsharedpreferences/getdefaultsharedpreferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _getdefaultsharedpreferencesPlugin = Getdefaultsharedpreferences();
  String value = "Hest";
  int count = 0;
  int kake = 10000000;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      value = await _getdefaultsharedpreferencesPlugin.getStringDefault("IABTCF_TCString",
              returnValue: "Kan ikke det nei") ??
          'Mofo!';
    } on PlatformException {
      value = 'Failed that bieatch!';
    }

    try {
      kake = await _getdefaultsharedpreferencesPlugin.getStringWithFileDefault("__GOOGLE_FUNDING_CHOICE_SDK_INTERNAL__", "consent_status",
          returnValue: 0) ??
          0;
    } on PlatformException {
      kake = -1000;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Key: $value\n'),
              Text('Kake: $kake\n'),
              TextButton(
                onPressed: () async {
                  count++;
                    try {
                      value = await _getdefaultsharedpreferencesPlugin
                              .getStringDefault("IABTCF_VendorConsents",
                                  returnValue: "Fant den ikke $count") ??
                          'Mofo!';
                    } on PlatformException {
                      value = 'blææææ!';
                    }

                    setState(() {});
                },
                child: Text("Hest"),
              ),

              TextButton(
                onPressed: () async {
                  count++;
                  try {
                    value = await _getdefaultsharedpreferencesPlugin
                        .getStringDefault("IABTCF_PurposeConsents",
                        returnValue: "Fant den ikke $count") ??
                        'Mofo!';
                  } on PlatformException {
                    value = 'blææææ!';
                  }

                  setState(() {});
                },
                child: Text("er"),
              ),

              TextButton(
                onPressed: () async {
                  count++;
                  try {
                    kake = await _getdefaultsharedpreferencesPlugin
                        .getStringWithFileDefault("__GOOGLE_FUNDING_CHOICE_SDK_INTERNAL__", "consent_status",
                        returnValue: count) ??
                        0;
                  } on PlatformException {
                    kake = -1235415;
                  }

                  setState(() {});
                },
                child: Text("best"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
