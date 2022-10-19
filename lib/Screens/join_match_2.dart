import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/join_final.dart';

class Result {
  final String written;
  final String subject;
  final String mcq;
  final String total;
  final String grade;
  final String grade_point;

  Result(
      {this.total,
      this.written,
      this.subject,
      this.mcq,
      this.grade,
      this.grade_point});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      subject: json['subject'],
      written: json['written'],
      mcq: json['mcq'],
      total: json['total'],
      grade: json['grade'],
      grade_point: json['grade_point'],
    );
  }
}

class join_match_2 extends StatefulWidget {
  @required
  final String id;
  @required
  final int type;
  join_match_2({this.id, this.type});
  @override
  _join_match_2State createState() => _join_match_2State();
}

class _join_match_2State extends State<join_match_2> {
  var teama = 4;
  List<Map> availableHobbies = [
    {"isChecked": false},
    {"isChecked": false},
    {
      "isChecked": false,
    },
  ];
  List<Map> av2 = [
    {"isChecked": false},
    {"isChecked": false},
    {"isChecked": false},
  ];
  Future fetchResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            AppUrl.join_matcvh2 + widget.id + '/' + widget.type.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // print(parsed.length);

      List jsonResponse = json.decode(response.body)['team_1_exits'] as List;
      setState(() {
        try_ = jsonResponse;
      });
      print(try_);
      print("This is reponse " + jsonResponse.toString());

      print(jsonResponse);

      return try_;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }
  Future fetchResult2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            AppUrl.join_matcvh2 + widget.id + '/' + widget.type.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // print(parsed.length);

      List jsonResponse = json.decode(response.body)['team_1_non_exit'] as List;
      setState(() {
        try_2 = jsonResponse;
      });
      print(try_2);
      print("This is reponse " + jsonResponse.toString());

      print(jsonResponse);

      return try_2;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }
  Future fetchResult3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            AppUrl.join_matcvh2 + widget.id + '/' + widget.type.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // print(parsed.length);

      List jsonResponse = json.decode(response.body)['team_2_exits'] as List;
      setState(() {
        try_3 = jsonResponse;
      });
      print(try_3);
      print("This is reponse " + jsonResponse.toString());

      print(jsonResponse);

      return try_3;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }
  Future fetchResult4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse(
            AppUrl.join_matcvh2 + widget.id + '/' + widget.type.toString()),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      // print(parsed.length);

      List jsonResponse = json.decode(response.body)['team_2_non_exit'] as List;
      setState(() {
        try_4 = jsonResponse;
      });
      print("This is reponse " + jsonResponse.toString());

      print(jsonResponse);

      return try_4;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }

  List try_ = [];
  List try_2 = [];
  List try_3 = [];
  List try_4 = [];
  List test = [0, 1, 1, 0, 0];
  Future _func,exist,func1,exist1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _func = fetchResult();
    exist=fetchResult2();
    func1 = fetchResult3();
    exist1=fetchResult4();
  }
  bool isChecked = false;
var select_number,team;
List selected=[];
List selected2=[];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Join Match",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text("Select Match Positioned",
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                ),
              ),
            ),
            Center(
              child: Text("Note player have a permission to change slot in game***",
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
            ),
           Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("একটি টিম সিলেক্ট করতে হবে ",
                    style: GoogleFonts.lato(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ),
            Row(
              children: [
                FutureBuilder(
                  future: _func,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      // print(data);
                      return Column(
                        children: [
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Team A : ",style: TextStyle(fontSize: 16),),
                                ),
                                snapshot.data.length>0?ListView.builder(
                                    itemCount:snapshot.data.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (_, index) {
                                      var data = snapshot.data[index];
                                      return  Checkbox(
                                          value: true,
                                          onChanged: (v) {
                                            return null;
                                          });
                                    }):Container(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return AlertDialog(
                        title: Text(
                          'An Error Occured!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        content: Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                    // By default, show a loading spinner.
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('This may take some time..')
                        ],
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: exist,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      // print(data);
                      return Column(
                        children: [
                          Container(
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                    itemCount:snapshot.data.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (_, index) {
                                      var data = snapshot.data[index];
                                      return  Checkbox(
                                        value: snapshot.data[index],
                                        onChanged: (value) {
                                          setState(() {
                                            snapshot.data[index] = value;
                                            team=1;
                                            print(value);
                                            value==true?selected.add(true):selected.remove(true);
print(selected.toString());
                                          });
                                        },
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return AlertDialog(
                        title: Text(
                          'An Error Occured!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        content: Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                    // By default, show a loading spinner.
                    return Container();
                  },
                ),
              ],
            ),
            Row(
              children: [
                FutureBuilder(
                  future: func1,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      // print(data);
                      return Column(
                        children: [
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Team B : ",style: TextStyle(fontSize: 16),),
                                ),
                               snapshot.data.length>0? ListView.builder(
                                    itemCount:snapshot.data.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (_, index) {
                                      return  Checkbox(
                                          value: true,
                                          onChanged: (v) {
                                            return null;
                                          });
                                    }):Container(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return AlertDialog(
                        title: Text(
                          'An Error Occured!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        content: Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                    // By default, show a loading spinner.
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('This may take some time..')
                        ],
                      ),
                    );
                  },
                ),
                FutureBuilder(
                  future: exist1,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      // print(data);
                      return Column(
                        children: [
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                    itemCount:snapshot.data.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (_, index) {
                                      var data = snapshot.data[index];
                                      return  Checkbox(
                                        value: snapshot.data[index],
                                        onChanged: (value) {
                                          setState(() {
                                            snapshot.data[index] = value;
                                            team=2;
                                            value==true?selected2.add(true):selected2.remove(true);
                                            print(selected2.toString());
                                          });
                                        },
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return AlertDialog(
                        title: Text(
                          'An Error Occured!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                        content: Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                    // By default, show a loading spinner.
                    return Container();
                  },
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  print(selected.length);
                  print(selected2.length);

                  selected.length>0 || selected2.length>0?
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>join_final(type: team==1?selected.length:selected2.length,id: widget.id,team: team.toString(),)))
:                  Fluttertoast.showToast(

                  msg: "Please select team first",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0);

                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Join Now",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ),


            //     Container(
            //     height: 100,
            //     child: Row(
            //
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Text("Team b : "),
            //         ListView.builder(
            //
            //             itemCount: widget.type,
            //             scrollDirection: Axis.horizontal,
            //             shrinkWrap: true,
            //             itemBuilder: (_,index){
            //               return Checkbox(value: test[index]==1?true:false, onChanged: (v){
            //
            //                 // setState(() {        // test.indexWhere((element) => );
            //                 //                     // // v==false?setState(() {
            //                 //                     // //   test[index] = v;
            //                 //                     // // }):null;
            //                 //
            //                 // });
            //               if( test[index]==0){
            // setState(() {
            //                       test[index] = v;
            // });
            //               }
            //               });
            //
            //             }),
            //
            //       ],
            //     ),
            //   )
          ],
        ),
      ),
    ));
  }
}
