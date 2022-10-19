import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/join_final.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/squad_final_join.dart';

class squad_join extends StatefulWidget {
  @required
  final String id;
  @required
  final int type;
  squad_join({this.id, this.type});
  @override
  _squad_joinState createState() => _squad_joinState();
}

class _squad_joinState extends State<squad_join> {
  var teama = 4;
  var fake_id;
  List<Map> availableHobbies = [
    {"isChecked": false, 'id': '1'},
    {"isChecked": true, 'id': '2'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
    {"isChecked": false, 'id': '3'},
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

      List jsonResponse = json.decode(response.body)['data'] as List;
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

      List jsonResponse = json.decode(response.body)['data1'] as List;
      List jsonResponse2 = json.decode(response.body)['data1'] as List;
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
  var player_id;
  getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token=prefs.getString('token');
    var user=prefs.getString('user_name');
    var id=prefs.getInt('id');
    var fname=prefs.getString('first_name');
    var lname=prefs.getString('last_name');
    var email=prefs.getString('email');
    var phone=prefs.getString('phone');
    setState(() {
      player_id=id;
    });
    print('Token '+token);
    print('id '+id.toString());
    print('fname= '+fname);
    print('lname '+lname);
    print('email '+email);
    print('phoneno '+phone);
    print('user '+user);
  }
  List try_ = [];
  List try_2 = [];
  List try_3 = [];
  List try_4 = [];
  List test = [0, 1, 1, 0, 0];
  Future _func, exist, func1, exist1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _func = fetchResult();
    exist = fetchResult2();
    getdata();
  }

  bool isChecked = false;
  var select_number, team;
  List selected = [];
  List slot = [];
  List team_array = [];
  List selected2 = [];
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
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
                        borderRadius: BorderRadius.circular(7)),
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
                  child: Text(
                      "Note player have a permission to change slot in game***",
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
                // FutureBuilder(
                //   future: _func,
                //   builder: (ctx, snapshot) {
                //     if (snapshot.hasData) {
                //       List data = snapshot.data;
                //       // print(data);
                //       return  snapshot.data.length > 0
                //           ? Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           height:height/3,
                //           child: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Expanded(
                //                 child: GridView.builder(
                //                     gridDelegate:
                //                     SliverGridDelegateWithFixedCrossAxisCount(
                //                         crossAxisCount: 4),
                //                     itemCount:
                //                     snapshot.data.length,
                //                     shrinkWrap: true,
                //                     itemBuilder: (_, index) {
                //                       var indexof = index + 1;
                //
                //                       return
                //                         try_[index]
                //                         ['user_id']!=0 && try_[index]
                //                         ['player_name'] !=
                //                             'x'
                //                             ? Row(
                //                           children: [
                //                             Text(
                //                                 indexof
                //                                     .toString(),
                //                                 style: GoogleFonts
                //                                     .lato(
                //                                   color: Colors
                //                                       .black,
                //                                   fontSize: 14,
                //                                   fontWeight:
                //                                   FontWeight
                //                                       .w600,
                //                                 )),
                //                             Checkbox(
                //                                 checkColor: Colors.white,
                //                                 fillColor:  MaterialStateColor.resolveWith((states) => Colors.grey),
                //                                 value: true,
                //
                //                                 onChanged: (v) {
                //                                   print('checked');
                //                                   return null;
                //                                 }),
                //                           ],
                //                         )
                //                             : Row(
                //                           children: [
                //                             Text(
                //                                 indexof
                //                                     .toString(),
                //                                 style: GoogleFonts
                //                                     .lato(
                //                                   color: Colors
                //                                       .black,
                //                                   fontSize: 14,
                //                                   fontWeight:
                //                                   FontWeight
                //                                       .w600,
                //                                 )),
                //                             Checkbox(
                //                                 value: try_[index]
                //                                 ['user_id']==0?false:true,
                //                                 onChanged: (v) {
                //                                   print('checked2');
                //
                //                                   setState(() {
                //                                     team=indexof.toString();
                //                                     fake_id=try_[index]
                //                                     ['id'];
                //
                //                                     if(try_[index]
                //                                     ['player_name']=='x'&&   try_[index]
                //                                     ['user_id'] ==player_id){
                //                                       //   try_[index]
                //                                       // ['player_name'] = 'a';
                //                                       try_[index]
                //                                       ['user_id'] = 0;}else{   try_[index]
                //                                     ['player_name'] = 'x';
                //                                     try_[index]
                //                                     ['user_id'] = player_id;}
                //                                     v==true?selected.add(true):selected.remove(true);
                //                                     print(selected.toString());
                //                                   });
                //                                 }),
                //                           ],
                //                         );
                //                     }),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //           : Container();
                //     }
                //     else if (snapshot.hasError) {
                //       return AlertDialog(
                //         title: Text(
                //           'An Error Occured!',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             color: Colors.redAccent,
                //           ),
                //         ),
                //         content: Text(
                //           "${snapshot.error}",
                //           style: TextStyle(
                //             color: Colors.blueAccent,
                //           ),
                //         ),
                //         actions: <Widget>[
                //           FlatButton(
                //             child: Text(
                //               'Go Back',
                //               style: TextStyle(
                //                 color: Colors.redAccent,
                //               ),
                //             ),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           )
                //         ],
                //       );
                //     }
                //     // By default, show a loading spinner.
                //     return Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           CircularProgressIndicator(),
                //           SizedBox(height: 20),
                //           Text('This may take some time..')
                //         ],
                //       ),
                //     );
                //   },
                // ),// FutureBuilder(
                //   future: _func,
                //   builder: (ctx, snapshot) {
                //     if (snapshot.hasData) {
                //       List data = snapshot.data;
                //       // print(data);
                //       return  snapshot.data.length > 0
                //           ? Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Container(
                //           height:height/3,
                //           child: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Expanded(
                //                 child: GridView.builder(
                //                     gridDelegate:
                //                     SliverGridDelegateWithFixedCrossAxisCount(
                //                         crossAxisCount: 4),
                //                     itemCount:
                //                     snapshot.data.length,
                //                     shrinkWrap: true,
                //                     itemBuilder: (_, index) {
                //                       var indexof = index + 1;
                //
                //                       return
                //                         try_[index]
                //                         ['user_id']!=0 && try_[index]
                //                         ['player_name'] !=
                //                             'x'
                //                             ? Row(
                //                           children: [
                //                             Text(
                //                                 indexof
                //                                     .toString(),
                //                                 style: GoogleFonts
                //                                     .lato(
                //                                   color: Colors
                //                                       .black,
                //                                   fontSize: 14,
                //                                   fontWeight:
                //                                   FontWeight
                //                                       .w600,
                //                                 )),
                //                             Checkbox(
                //                                 checkColor: Colors.white,
                //                                 fillColor:  MaterialStateColor.resolveWith((states) => Colors.grey),
                //                                 value: true,
                //
                //                                 onChanged: (v) {
                //                                   print('checked');
                //                                   return null;
                //                                 }),
                //                           ],
                //                         )
                //                             : Row(
                //                           children: [
                //                             Text(
                //                                 indexof
                //                                     .toString(),
                //                                 style: GoogleFonts
                //                                     .lato(
                //                                   color: Colors
                //                                       .black,
                //                                   fontSize: 14,
                //                                   fontWeight:
                //                                   FontWeight
                //                                       .w600,
                //                                 )),
                //                             Checkbox(
                //                                 value: try_[index]
                //                                 ['user_id']==0?false:true,
                //                                 onChanged: (v) {
                //                                   print('checked2');
                //
                //                                   setState(() {
                //                                     team=indexof.toString();
                //                                     fake_id=try_[index]
                //                                     ['id'];
                //
                //                                     if(try_[index]
                //                                     ['player_name']=='x'&&   try_[index]
                //                                     ['user_id'] ==player_id){
                //                                       //   try_[index]
                //                                       // ['player_name'] = 'a';
                //                                       try_[index]
                //                                       ['user_id'] = 0;}else{   try_[index]
                //                                     ['player_name'] = 'x';
                //                                     try_[index]
                //                                     ['user_id'] = player_id;}
                //                                     v==true?selected.add(true):selected.remove(true);
                //                                     print(selected.toString());
                //                                   });
                //                                 }),
                //                           ],
                //                         );
                //                     }),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //           : Container();
                //     }
                //     else if (snapshot.hasError) {
                //       return AlertDialog(
                //         title: Text(
                //           'An Error Occured!',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             color: Colors.redAccent,
                //           ),
                //         ),
                //         content: Text(
                //           "${snapshot.error}",
                //           style: TextStyle(
                //             color: Colors.blueAccent,
                //           ),
                //         ),
                //         actions: <Widget>[
                //           FlatButton(
                //             child: Text(
                //               'Go Back',
                //               style: TextStyle(
                //                 color: Colors.redAccent,
                //               ),
                //             ),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           )
                //         ],
                //       );
                //     }
                //     // By default, show a loading spinner.
                //     return Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           CircularProgressIndicator(),
                //           SizedBox(height: 20),
                //           Text('This may take some time..')
                //         ],
                //       ),
                //     );
                //   },
                // ),


                //****test//


                // Text(try_.toString()),
                // Row
                //   children: [
                //     FutureBuilder(
                //       future: func1,
                //       builder: (ctx, snapshot) {
                //         if (snapshot.hasData) {
                //           List data = snapshot.data;
                //           // print(data);
                //           return Column(
                //             children: [
                //               Container(
                //                 height: 100,
                //                 child: Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.all(8.0),
                //                       child: Text(
                //                         "Team B : ",
                //                         style: TextStyle(fontSize: 16),
                //                       ),
                //                     ),
                //                     snapshot.data.length > 0
                //                         ? ListView.builder(
                //                             itemCount: snapshot.data.length,
                //                             scrollDirection: Axis.horizontal,
                //                             shrinkWrap: true,
                //                             itemBuilder: (_, index) {
                //                               return Checkbox(
                //                                   value: true,
                //                                   onChanged: (v) {
                //                                     return null;
                //                                   });
                //                             })
                //                         : Container(),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           );
                //         } else if (snapshot.hasError) {
                //           return AlertDialog(
                //             title: Text(
                //               'An Error Occured!',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 color: Colors.redAccent,
                //               ),
                //             ),
                //             content: Text(
                //               "${snapshot.error}",
                //               style: TextStyle(
                //                 color: Colors.blueAccent,
                //               ),
                //             ),
                //             actions: <Widget>[
                //               FlatButton(
                //                 child: Text(
                //                   'Go Back',
                //                   style: TextStyle(
                //                     color: Colors.redAccent,
                //                   ),
                //                 ),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               )
                //             ],
                //           );
                //         }
                //         // By default, show a loading spinner.
                //         return Center(
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               CircularProgressIndicator(),
                //               SizedBox(height: 20),
                //               Text('This may take some time..')
                //             ],
                //           ),
                //         );
                //       },
                //     ),
                //     FutureBuilder(
                //       future: exist1,
                //       builder: (ctx, snapshot) {
                //         if (snapshot.hasData) {
                //           List data = snapshot.data;
                //           // print(data);
                //           return Column(
                //             children: [
                //               Container(
                //                 height: 100,
                //                 child: Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     ListView.builder(
                //                         itemCount: snapshot.data.length,
                //                         scrollDirection: Axis.horizontal,
                //                         shrinkWrap: true,
                //                         itemBuilder: (_, index) {
                //                           var data = snapshot.data[index];
                //                           return Checkbox(
                //                             value: snapshot.data[index],
                //                             onChanged: (value) {
                //                               setState(() {
                //                                 snapshot.data[index] = value;
                //                                 team = 2;
                //                                 value == true
                //                                     ? selected2.add(true)
                //                                     : selected2.remove(true);
                //                                 print(selected2.toString());
                //                               });
                //                             },
                //                           );
                //                         }),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           );
                //         } else if (snapshot.hasError) {
                //           return AlertDialog(
                //             title: Text(
                //               'An Error Occured!',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 color: Colors.redAccent,
                //               ),
                //             ),
                //             content: Text(
                //               "${snapshot.error}",
                //               style: TextStyle(
                //                 color: Colors.blueAccent,
                //               ),
                //             ),
                //             actions: <Widget>[
                //               FlatButton(
                //                 child: Text(
                //                   'Go Back',
                //                   style: TextStyle(
                //                     color: Colors.redAccent,
                //                   ),
                //                 ),
                //                 onPressed: () {
                //                   Navigator.of(context).pop();
                //                 },
                //               )
                //             ],
                //           );
                //         }
                //         // By default, show a loading spinner.
                //         return Container();
                //       },
                //     ),
                //   ],
                // ),
                FutureBuilder(
                  future: exist,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      List data = snapshot.data;
                      // print(data);
                      return Column(
                        children: [
                          Container(
                            height:height/1.4,
                            child: snapshot.data.length > 0
                                ? ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  var indexof = index + 1;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: height/20,
                                      width: width,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,

                                        children: [
                                          Text('Team  $indexof' +'  -  ',style:TextStyle(fontSize:16,fontWeight: FontWeight.bold)),
                                          SizedBox(width: 20,),
                                          Expanded(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot.data[index]['game_player_count'].length,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (_,i){                              var indexof3 = i + 1;

                                                return Container(child: Row(
                                                  children: [ Text(' $indexof3',style:TextStyle(fontSize:16,fontWeight: FontWeight.bold)),

                                                    snapshot.data[index]['game_player_count'][i]
                                                    ['user_id']!=0 && snapshot.data[index]['game_player_count'][i]
                                                    ['player_name'] !=
                                                        'x'
                                                        ? Row(
                                                      children: [

                                                        Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor:  MaterialStateColor.resolveWith((states) => Colors.grey),
                                                            value: true,

                                                            onChanged: (v) {
                                                              print('checked');
                                                              return null;
                                                            }),
                                                      ],
                                                    )
                                                        : Row(
                                                      children: [

                                                        Checkbox(
                                                            value: snapshot.data[index]['game_player_count'][i]
                                                            ['user_id']==0?false:true,
                                                            onChanged: (v) {
                                                              print('checked2');
                                                              v==true?selected2.add(true):selected2.remove(true);
                                                              v==true?slot.add(snapshot.data[index]['game_player_count'][i]['id']):slot.remove(snapshot.data[index]['game_player_count'][i]['id']);
                                                              v==true?team_array.add(snapshot.data[index]['game_player_count'][i]
                                                              ['team_type']):team_array.remove(snapshot.data[index]['game_player_count'][i]
                                                              ['team_type']);
                                                              print(slot.toString());
                                                              print('team_id');
                                                              print(team_array.toString());

                                                              selected2.length<=4?

                                                              setState(() {
                                                                ['team_type'].toString();
                                                                fake_id=snapshot.data[index]['game_player_count'][i]
                                                                ['id'];

                                                                if(snapshot.data[index]['game_player_count'][i]
                                                                ['player_name']=='x'&&   snapshot.data[index]['game_player_count'][i]
                                                                ['user_id'] ==player_id){
                                                                  //   try_[index]
                                                                  // ['player_name'] = 'a';
                                                                  snapshot.data[index]['game_player_count'][i]
                                                                  ['user_id'] = 0;}else{   snapshot.data[index]['game_player_count'][i]
                                                                ['player_name'] = 'x';
                                                                snapshot.data[index]['game_player_count'][i]
                                                                ['user_id'] = player_id;}
                                                                v==true?selected.add(true):selected.remove(true);
                                                                print(selected.toString());
                                                              }):Fluttertoast.showToast(
                                                                  msg: "Can't Select More than four slot",
                                                                  toastLength: Toast.LENGTH_LONG,
                                                                  gravity: ToastGravity.BOTTOM,
                                                                  timeInSecForIosWeb: 1,
                                                                  backgroundColor: Colors.red,
                                                                  textColor: Colors.white,
                                                                  fontSize: 16.0);
                                                            }),
                                                      ],
                                                    )                                                        ],
                                                ));
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : Container(),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     color: Colors.red,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Expanded(
                //           child: ListView.builder(
                //               // gridDelegate:
                //               // SliverGridDelegateWithFixedCrossAxisCount(
                //               //     crossAxisCount: 4),
                //               itemCount:
                //               10,
                //               shrinkWrap: true,
                //               itemBuilder: (_, index) {
                //                 var indexof = index + 1;
                //
                //                 return
                //                   try_[index]
                //                   ['user_id']!=0 && try_[index]
                //                   ['player_name'] !=
                //                       'x'
                //                       ? Row(
                //                     children: [
                //                       Text(
                //                           indexof
                //                               .toString(),
                //                           style: GoogleFonts
                //                               .lato(
                //                             color: Colors
                //                                 .black,
                //                             fontSize: 14,
                //                             fontWeight:
                //                             FontWeight
                //                                 .w600,
                //                           )),
                //                       Checkbox(
                //                           checkColor: Colors.white,
                //                           fillColor:  MaterialStateColor.resolveWith((states) => Colors.grey),
                //                           value: true,
                //
                //                           onChanged: (v) {
                //                             print('checked');
                //                             return null;
                //                           }),
                //                     ],
                //                   )
                //                       : Row(
                //                     children: [
                //                       Text(
                //                           indexof
                //                               .toString(),
                //                           style: GoogleFonts
                //                               .lato(
                //                             color: Colors
                //                                 .black,
                //                             fontSize: 14,
                //                             fontWeight:
                //                             FontWeight
                //                                 .w600,
                //                           )),
                //                       Checkbox(
                //                           value: try_[index]
                //                           ['user_id']==0?false:true,
                //                           onChanged: (v) {
                //                             print('checked2');
                //
                //                             setState(() {
                //                               team=indexof.toString();
                //                               fake_id=try_[index]
                //                               ['id'];
                //
                //                               if(try_[index]
                //                               ['player_name']=='x'&&   try_[index]
                //                               ['user_id'] ==player_id){
                //                                 //   try_[index]
                //                                 // ['player_name'] = 'a';
                //                                 try_[index]
                //                                 ['user_id'] = 0;}else{   try_[index]
                //                               ['player_name'] = 'x';
                //                               try_[index]
                //                               ['user_id'] = player_id;}
                //                               v==true?selected.add(true):selected.remove(true);
                //                               print(selected.toString());
                //                             });
                //                           }),
                //                     ],
                //                   );
                //               }),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      print(selected.length);

                      selected.length > 0
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => squad_join_final(
                                slot_array: slot,
                                type:selected.length,
                                id: widget.id,
                                team_array: team_array,
                                fakeid: fake_id.toString(),
                              )))
                          : Fluttertoast.showToast(
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
                          borderRadius: BorderRadius.circular(7)),
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

                // Container(
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Expanded(
                //         child: GridView.builder(
                //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //                 crossAxisCount: 4),
                //             itemCount: availableHobbies.length,
                //             shrinkWrap: true,
                //             itemBuilder: (_, index) {
                //               var indexof = index + 1;
                //
                //               return availableHobbies[index]['id'] != 'x' &&
                //                       availableHobbies[index]['isChecked'] == true
                //                   ? Row(
                //                       children: [
                //                         Text(indexof.toString(),
                //                             style: GoogleFonts.lato(
                //                               color: Colors.black,
                //                               fontSize: 14,
                //                               fontWeight: FontWeight.w600,
                //                             )),
                //                         Checkbox(
                //                             value: true,
                //                             onChanged: (v) {
                //                               return null;
                //                             }),
                //                       ],
                //                     )
                //                   : Row(
                //                       children: [
                //                         Text(indexof.toString(),
                //                             style: GoogleFonts.lato(
                //                               color: Colors.black,
                //                               fontSize: 14,
                //                               fontWeight: FontWeight.w600,
                //                             )),
                //                         Checkbox(
                //                             value: availableHobbies[index]
                //                                 ['isChecked'],
                //                             onChanged: (v) {
                //                               setState(() {
                //                                 availableHobbies[index]['id'] = 'x';
                //                                 availableHobbies[index]
                //                                     ['isChecked'] = v;
                //                               });
                //                             }),
                //                       ],
                //                     );
                //             }),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //     child: Row(
                //
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Text("Team b : "),
                //         GridView.builder(
                //           itemCount: availableHobbies.length,
                //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                //           itemBuilder: (_, i) {
                //             return Stack(
                //               children: [
                //                 Container(color: Colors.red[(i * 100) % 900]),
                //                 Align(
                //                   alignment: Alignment.topCenter,
                //                   child: Checkbox(
                //                     value: _checks[i],
                //                     onChanged: (newValue) => setState(() => _checks[i] = newValue),
                //                   ),
                //                 ),
                //               ],
                //             );
                //           },
                //         ),
                //
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ));
  }
}
