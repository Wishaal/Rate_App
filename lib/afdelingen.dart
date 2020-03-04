import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Afdelingen {
  String afdeling;

  Afdelingen({this.afdeling});

  factory Afdelingen.fromJson(Map<String, dynamic> json){
    return Afdelingen(
        afdeling : json['afdeling']
    );
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["afdeling"] = afdeling;

    return map;
  }
}

String prefStored;

addStringToSF(val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('stringValue', val);
}

removeValues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Remove String
  prefs.remove("stringValue");
}



class AfdelingenData extends StatefulWidget {
  @override
  AfdelingenState createState() => AfdelingenState();
}

class AfdelingenState extends State<AfdelingenData> {
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefStored = (prefs.getString('stringValue')??'');
    });
  }

  final String url = "http://190.98.22.130/getafdelingen.php";
  List data;

  Future<String> getAfdelingenData() async {
    var res = await http.get(url);

    setState(() {
      var resrBody = json.decode(res.body);
      data = resrBody["data"];
    });

    return "success!";
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Branches"),
      ),
      body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: _getListItemTile,
      ),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return Container(
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  child: new InkWell(
                    onTap: () {
                      removeValues();
                      addStringToSF(data[index]["afdeling"]);
                      setState((){
                        prefStored = data[index]["afdeling"];
                      });
                      print(prefStored);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: new ListTile(
                          trailing: new Icon(prefStored  == data[index]["afdeling"] ? Icons.check_box : Icons.check_box_outline_blank,),
                          title: Text(data[index]["afdeling"]),
                        ),
                      color:  prefStored  == data[index]["afdeling"] ? Colors.amber : Colors.white,
                  ),
                  )
                )],
            )
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    this.getAfdelingenData();
  }
}