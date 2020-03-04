import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Rate_Telesur/afdelingen.dart';
import 'package:Rate_Telesur/login.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


final CREATE_POST_URL = 'LINK';
bool _showAppbar = false; //this is to show app bar

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        backgroundColor: Colors.white
      ),
      home:
      MyHomePage(),
    ),
  );
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('stringValue');
  return stringValue;
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future navigateToSubPage(context) async {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoginPage()));
}

class Rating {
  String branch;
  String rating;

  Rating({this.branch,this.rating});

  factory Rating.fromJson(Map<String, dynamic> json){
    return Rating(
        branch : json['branch'],
        rating : json['rating']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["branch"] = branch;
    map["rating"] = rating;

    return map;
  }
}

Future<Rating> createRating(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Rating.fromJson(json.decode(response.body));
  });
}

Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        title: Text('Telesur'),
        content: const Text('Bedankt voor Uw medewerking'),
      );
    },
  );
}

Future<void> _ackAlertLeeg(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        title: Text('Telesur'),
        content: const Text('Branche is leeg!'),
      );
    },
  );
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]);
    return Scaffold(
      appBar: _showAppbar ? AppBar(
        title: Text('Telesur Rating App'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: () { navigateToSubPage(context);})
        ],
      ) : null,
      body: Center(
          child: Column(children: <Widget>[
            Spacer(flex: 1),
            buildLogoRow(),
            Spacer(flex: 1),
            buildTextRow(),
            Spacer(flex: 1),
            buildRow(),
            Spacer(flex: 1),
          ],)
      ),
      backgroundColor: Colors.white,
    );
  }


  Widget buildRow() =>
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Spacer(flex: 1),
            Expanded(
              child:
                GestureDetector(
                  onTap: () async {

                    String data = await getStringValuesSF();
                    if(data == null){
                      _ackAlertLeeg(context);
                    }else {
                      _ackAlert(context);
                      Rating newRating = new Rating(branch: data, rating: "1");
                      Rating p = await createRating(CREATE_POST_URL,body: newRating.toMap());
                    }

                  },
                  child: Image.asset('assets/terrible.png'
                  ),
                ),
            flex: 2,),
              Spacer(flex: 1),
            Expanded(
              child:
              GestureDetector(
                onTap: () async {

                  String data = await getStringValuesSF();
                  if(data == null){
                    _ackAlertLeeg(context);
                  }else {
                    _ackAlert(context);
                    Rating newRating = new Rating(branch: data, rating: "2");
                    Rating p = await createRating(CREATE_POST_URL,body: newRating.toMap());
                  }

                },
                child: Image.asset('assets/sad.png'
                ),
              ),
            flex: 2,),
              Spacer(flex: 1),
            Expanded(
              child:
              GestureDetector(
                onTap: () async {

                  String data = await getStringValuesSF();
                  if(data == null){
                    _ackAlertLeeg(context);
                  }else {
                    _ackAlert(context);
                    Rating newRating = new Rating(branch: data, rating: "3");
                    Rating p = await createRating(CREATE_POST_URL,body: newRating.toMap());
                  }

                },
                child: Image.asset('assets/ok.png'
                ),
              ),
            flex: 2,),
              Spacer(flex: 1),
            Expanded(
              child:
              GestureDetector(
                onTap: () async {

                  String data = await getStringValuesSF();
                  if(data == null){
                    _ackAlertLeeg(context);
                  }else {
                    _ackAlert(context);
                    Rating newRating = new Rating(branch: data, rating: "4");
                    Rating p = await createRating(CREATE_POST_URL,body: newRating.toMap());
                  }

                },
                child: Image.asset('assets/great.png'
                ),
              ),
            flex: 2,),
              Spacer(flex: 1),
            Expanded(
              child:
              GestureDetector(
                onTap: () async {

                  String data = await getStringValuesSF();
                  if(data == null){
                    _ackAlertLeeg(context);
                  }else {
                    _ackAlert(context);
                    Rating newRating = new Rating(branch: data, rating: "5");
                    Rating p = await createRating(CREATE_POST_URL,body: newRating.toMap());
                  }

                },
                child: Image.asset('assets/supergreat.png'
                ),
              ),
            flex: 2,),
              Spacer(flex: 1)
            ],
        );

  Widget buildLogoRow() =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Expanded(
              child:
            GestureDetector(
              onLongPress: () {
                setState(() {
                  if(_showAppbar == true){
                    _showAppbar = false;
                  }else{
                    _showAppbar = true;
                  }

                });
              },
              child: Image.asset('assets/telesur.png', height: 175,),
            )
          )
        ],
      );

  Widget buildTextRow() =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [Text('Hoe blij bent u met onze service vandaag?',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30 ,color: Colors.blue[900])),],
      );
// #enddocregion Row

}
