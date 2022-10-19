import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/me/depostie.dart';
import '../mainHome.dart';
class DynamicWidget extends StatelessWidget {

  TextEditingController player_name = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height/20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(
                              0.2),

                          spreadRadius: 2,

                          blurRadius: 7,

                          offset: Offset(2,
                              1), // changes position of shadow
                        )
                      ],
                    ),

                    child: TextField(
                      inputFormatters: [
                        new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                      ],
                      controller: player_name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Player Name'
                      ),
                    ),
                  ),
                )
            ),

          ],
        ),
      ),
    );
  }
}

class join_duo_final extends StatefulWidget {
  final String id,fakeid;
  final List slot_array,team_array;
  final int type;
  join_duo_final({this.id,this.team_array,this.type,this.fakeid,this.slot_array});

  @override
  _join_duo_finalState createState() => _join_duo_finalState();
}

class _join_duo_finalState extends State<join_duo_final> {
  TextEditingController player1 = TextEditingController();
  TextEditingController player2 = TextEditingController();
  TextEditingController player3 = TextEditingController();
  TextEditingController player4 = TextEditingController();

  List player = [];
  var selected_country;
  var selected_country2;
  final _formKey = GlobalKey<FormState>();
  final _formKey_duo = GlobalKey<FormState>();
  final _formKey_squad = GlobalKey<FormState>();
  final _formKey_th = GlobalKey<FormState>();
  Future slide;
  Future emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.game_details + widget.id),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  String nid, birth;
  static const due = <String>[
    "1 player",
    "2 Player",
  ];
  String selectedValue = due.first;

  static const Squadg = <String>[
    "1 player",
    "2 Player",

    "4 player"

  ];  String selectedValuesquad ;
  var player_id;
  func()async{
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);
    setState(() {
      player_id=playerId;
    });


  }

  List<DynamicWidget> listDynamic = [];
  List<String> data = [];
  List<String> days_data = [];
  List<String> when_eats_data = [];
  List<String> quantity = [];
  addDynamic() {

    for(int i=0;i<widget.type;i++)


    {
      listDynamic.add(new DynamicWidget());
    }
  }
  submitData(int entryfee,int balance) async {

    listDynamic.forEach((widget) => data.add(widget.player_name.text));

    setState(() {});

    print('test');
    print(data);



    String p = data.toString();
    String newplayer = p.substring(1, p.length - 1);
    print(newplayer);
    if (balance >=
        entryfee) {
      setState(() {
        joined = true;
      });


      print(newplayer);
      Joinmatch(
          newplayer.toString(),
          widget.id,
          entryfee,);
    } else {
      setState(() {
        joined = false;
      });
      setState(() {
        add = true;
      });
      Fluttertoast.showToast(
          msg:
          "You don't have Sufficient Balance",
          toastLength: Toast
              .LENGTH_LONG,
          gravity:
          ToastGravity
              .BOTTOM,
          timeInSecForIosWeb:
          1,
          backgroundColor:
          Colors.red,
          textColor:
          Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slide = emergency();
    func();
    print('taut');
    print(widget.type);
    addDynamic();
    // notification_timer=Timer.periodic(Duration(seconds: 10), (_) => slide = emergency());

  }

  bool add=false;
  bool joined = false;
  Joinmatch(String player, match_id, int entry) async {
    print(player.toString());
    print(match_id);
    String q = widget.slot_array.toString();
    String slot = q.substring(1, q.length - 1);
    print(slot); String r = widget.team_array.toString();
    String ta = r.substring(1, r.length - 1);
    print(ta);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.join_match + match_id),
    );
    request.fields.addAll({'player': player, 'amount': entry.toString(),
      'fake_id_2':slot,
      'team_type':ta,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var userData = jsonDecode(response.body);
          if(userData['status_code']==200){
            setState(() {
              joined = false;
            });
            print(response.body);
            Fluttertoast.showToast(
                msg: "Joined the match Successfully.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print(userData);

            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          }else{
            var userData = jsonDecode(response.body);
            setState(() {
              joined=false;
            });
            print(userData);

            Fluttertoast.showToast(
                msg: userData['message'],
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          }
        }
        else {
          setState(() {
            joined = false;
          });
          print(response.body);

          print("Fail! ");
          Fluttertoast.showToast(
              msg: "Failed to Join",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          return response.body;
        }
      });
    });
  }
  var val,val2,val3,val4;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.clear();
    // notification_timer.cancel();

  }
  Timer notification_timer;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF07031E),
      appBar: AppBar(
        backgroundColor:Color(0xFF07031E),
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
            Container(
                constraints: BoxConstraints(),
                child: FutureBuilder(
                    future: slide,
                    builder: (_, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            child: SpinKitThreeInOut(
                              color: Colors.white,
                              size: 20,
                            ),
                          );
                        default:
                          if (snapshot.hasError) {
                            Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.hasData
                                ? SingleChildScrollView(
                                child: Container(
                                    height: height * 1.2,
                                    child: Container(
                                        child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Container(
                                                  height: height / 5,
                                                  width: width / 1,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      color: Colors.white),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                              child: Text(
                                                                  snapshot.data['game'][
                                                                  'title'] +
                                                                      " | " +
                                                                      snapshot.data['game']
                                                                      ['type'] +
                                                                      ' | ' +
                                                                      snapshot.data['game'][
                                                                      'control_type'] +
                                                                      ' | ' +
                                                                      snapshot.data[
                                                                      'game']
                                                                      [
                                                                      'game_id'],
                                                                  style: GoogleFonts.lato(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                      fontSize:
                                                                      18)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "  Available Balance :  " ,
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                        fontSize: 16)),
                                                                Image.asset('Images/t.png',height: 25,width: 25,),
                                                                Text(
                                                                    "  " +
                                                                        snapshot.data[
                                                                        'balance']
                                                                            .toString(),
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                        fontSize: 16)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "  Match Entry Fee Per Person :  ",
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                        fontSize: 16)),                                                                        Image.asset('Images/t.png',height: 25,width: 25,),
                                                                Text(
                                                                    "   " +
                                                                        snapshot.data[
                                                                        'game'][
                                                                        'entry_fee'],
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                        fontSize: 16)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),

                                                      Center(
                                                        child: Container(
                                                            height: height / 25,
                                                            width: width / 4,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                color:
                                                                Colors.orange),
                                                            child: Center(
                                                              child: Text(
                                                                snapshot.data[
                                                                'left']
                                                                    .toString() +
                                                                    " spots left",
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    fontSize: 14),
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Container(
                                                  width: width / 1,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      color: Colors.white),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child: InkWell(
                                                                onTap: () {

                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Center(
                                                                            child: Text(
                                                                                "আপনার গেইম আইডি ৪০+ থাকতে হবে",
                                                                                style: GoogleFonts.lato(
                                                                                    color: Colors
                                                                                        .red,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w700,
                                                                                    fontSize:
                                                                                    16)),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),

                                                                    Text(
                                                                        " Enter Exact FreeFire In Game Name",
                                                                        style: GoogleFonts.lato(
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                            fontSize:
                                                                            16)),
                                                                    // Row(
                                                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                                                    //   children: [
                                                                    //     Text(
                                                                    //         " Team Name : ",
                                                                    //         style: GoogleFonts.lato(
                                                                    //             color: Colors
                                                                    //                 .black,
                                                                    //             fontWeight:
                                                                    //             FontWeight
                                                                    //                 .w700,
                                                                    //             fontSize:
                                                                    //             16)),   Text(
                                                                    //         widget.team=='1'?"Team A":"Team B",
                                                                    //         style: GoogleFonts.lato(
                                                                    //             color: Colors
                                                                    //                 .orange,
                                                                    //             fontWeight:
                                                                    //             FontWeight
                                                                    //                 .w700,
                                                                    //             fontSize:
                                                                    //             16)),
                                                                    //   ],
                                                                    // ),
                                                                    Padding(
                                                                      padding:
                                                                      const EdgeInsets.all(
                                                                          8.0),
                                                                      child: Text(
                                                                          "*** প্রতি জন এর নাম লেখার পর কিবোর্ড এর ইন্টার/ডান ক্লিক করে নেক্সট প্লেয়ারের নাম লিখতে হবে",
                                                                          style: GoogleFonts.lato(
                                                                              color:
                                                                              Colors.red,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: widget.type,
                                                        itemBuilder: (_, index) => listDynamic[index],
                                                      ),
                                                      //         selected_country == '2 Player'
                                                      //             ? Form(
                                                      //           key: _formKey,
                                                      //           child: Padding(
                                                      //             padding:
                                                      //             const EdgeInsets
                                                      //                 .all(8.0),
                                                      //             child: Column(
                                                      //               children: [
                                                      //                 TextFormField(
                                                      //                   inputFormatters: [
                                                      //                     new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                   ],
                                                      //                   controller:
                                                      //                   player1,
                                                      //                   validator: (v) => v
                                                      //                       .isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border:
                                                      //                       OutlineInputBorder(),
                                                      //                       hintText:
                                                      //                       "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //                 SizedBox(
                                                      //                   height: 10,
                                                      //                 ),
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player2,
                                                      //                   validator: (v) => v
                                                      //                       .isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border:
                                                      //                       OutlineInputBorder(),
                                                      //                       hintText:
                                                      //                       "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val2=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //               ],
                                                      //             ),
                                                      //           ),
                                                      //         )
                                                      //             : selected_country ==
                                                      //             '3 player'
                                                      //             ? Form(
                                                      //           key: _formKey,
                                                      //           child: Padding(
                                                      //             padding:
                                                      //             const EdgeInsets
                                                      //                 .all(
                                                      //                 8.0),
                                                      //             child: Column(
                                                      //               children: [
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player1,
                                                      //                   validator: (v) => v
                                                      //                       .isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border:
                                                      //                       OutlineInputBorder(),
                                                      //                       hintText:
                                                      //                       "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //                 SizedBox(
                                                      //                   height:
                                                      //                   10,
                                                      //                 ),
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player2,
                                                      //                   validator: (v) => v
                                                      //                       .isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border:
                                                      //                       OutlineInputBorder(),
                                                      //                       hintText:
                                                      //                       "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val2=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //                 SizedBox(
                                                      //                   height:
                                                      //                   10,
                                                      //                 ),
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player3,
                                                      //                   validator: (v) => v
                                                      //                       .isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border:
                                                      //                       OutlineInputBorder(),
                                                      //                       hintText:
                                                      //                       "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val3=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //               ],
                                                      //             ),
                                                      //           ),
                                                      //         )
                                                      //             : selected_country ==
                                                      //             '4 player'
                                                      //             ? Form(
                                                      //           key:
                                                      //           _formKey,
                                                      //           child:
                                                      //           Padding(
                                                      //             padding:
                                                      //             const EdgeInsets.all(
                                                      //                 8.0),
                                                      //             child:
                                                      //             Column(
                                                      //               children: [
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player1,
                                                      //                   validator: (v) => v.isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border: OutlineInputBorder(),
                                                      //                       hintText: "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //                 SizedBox(
                                                      //                   height:
                                                      //                   10,
                                                      //                 ),
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player2,
                                                      //                   validator: (v) => v.isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border: OutlineInputBorder(),
                                                      //                       hintText: "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val2=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //                 SizedBox(
                                                      //                   height:
                                                      //                   10,
                                                      //                 ),
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player3,
                                                      //                   validator: (v) => v.isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border: OutlineInputBorder(),
                                                      //                       hintText: "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val3=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //                 SizedBox(
                                                      //                   height:
                                                      //                   10,
                                                      //                 ),
                                                      //                 TextFormField( inputFormatters: [
                                                      //                   new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //                 ],
                                                      //                   controller:
                                                      //                   player4,
                                                      //                   validator: (v) => v.isEmpty
                                                      //                       ? "Can't be empty"
                                                      //                       : null,
                                                      //                   decoration: InputDecoration(
                                                      //                       border: OutlineInputBorder(),
                                                      //                       hintText: "Enter player in game name"),
                                                      //                   onChanged: (value){
                                                      //                     var tr=value;
                                                      //                     setState(() {
                                                      //                       val4=tr;
                                                      //                     });
                                                      //                   },
                                                      //                 ),
                                                      //               ],
                                                      //             ),
                                                      //           ),
                                                      //         )
                                                      //             : Form(
                                                      //           key: _formKey,
                                                      //           child:
                                                      //           Padding(
                                                      //             padding:
                                                      //             const EdgeInsets.all(
                                                      //                 8.0),
                                                      //             child:
                                                      //             TextFormField( inputFormatters: [
                                                      //               new  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                                      //             ],
                                                      //               controller:
                                                      //               player1,
                                                      //               validator: (v) => v
                                                      //                   .isEmpty
                                                      //                   ? "Can't be empty"
                                                      //                   : null,
                                                      //               decoration: InputDecoration(
                                                      //                   border:
                                                      //                   OutlineInputBorder(),
                                                      //                   hintText:
                                                      //                   "Enter player in game name"),
                                                      //               onChanged: (value){
                                                      //                 var tr=value;
                                                      //                 setState(() {
                                                      //                   val=tr;
                                                      //                 });
                                                      //               },
                                                      //             ),
                                                      //           ),
                                                      //         )
                                                      //       ],
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      joined == false
                                                          ? Align(
                                                        alignment:
                                                        Alignment.bottomCenter,
                                                        child: Center(
                                                          child: InkWell(
                                                            onTap: () {

                                                              if(add==true){
                                                                Navigator.push(context, MaterialPageRoute(builder: (_)=>deposite()));
                                                              }else{
                                                                // if(_formKey.currentState.validate()){
                                                                //   var entry = int.parse(
                                                                //       snapshot.data[
                                                                //       'game']
                                                                //       ['entry_fee']);
                                                                //   var calculate = selected_country ==
                                                                //       '1 player'
                                                                //       ? entry
                                                                //       : selected_country ==
                                                                //       '2 Player'
                                                                //       ? entry * 2
                                                                //       : selected_country ==
                                                                //       '3 player'
                                                                //       ? entry * 3
                                                                //       :selected_country ==
                                                                //       '4 player'? entry * 4:entry;
                                                                //   print(calculate);
                                                                //
                                                                //   if (snapshot.data[
                                                                //   'balance'] >=
                                                                //       calculate) {
                                                                //     setState(() {
                                                                //       joined = true;
                                                                //     });
                                                                //     if(val!=null){
                                                                //       player.add(val);
                                                                //
                                                                //     } if(val2!=null){
                                                                //       player.add(val2);
                                                                //
                                                                //     }if(val3!=null){
                                                                //       player.add(val3);
                                                                //
                                                                //     }if(val4!=null){
                                                                //       player.add(val4);
                                                                //
                                                                //     }
                                                                //
                                                                //     print(player);
                                                                //     Joinmatch(
                                                                //         player,
                                                                //         widget.id,
                                                                //         calculate);
                                                                //   } else {
                                                                //     setState(() {
                                                                //       joined = false;
                                                                //     });
                                                                //     setState(() {
                                                                //       add = true;
                                                                //     });
                                                                //     Fluttertoast.showToast(
                                                                //         msg:
                                                                //         "You don't have Sufficient Balance",
                                                                //         toastLength: Toast
                                                                //             .LENGTH_LONG,
                                                                //         gravity:
                                                                //         ToastGravity
                                                                //             .BOTTOM,
                                                                //         timeInSecForIosWeb:
                                                                //         1,
                                                                //         backgroundColor:
                                                                //         Colors.red,
                                                                //         textColor:
                                                                //         Colors.white,
                                                                //         fontSize: 16.0);
                                                                //   }
                                                                // }
                                                                var entry = int.parse(
                                                                    snapshot.data[
                                                                    'game']
                                                                    ['entry_fee']);
                                                                var calculate=widget.type*entry;
                                                                submitData(calculate,snapshot.data[
                                                                'balance']);

                                                              }

                                                            },
                                                            child: Container(
                                                                height: height / 22,
                                                                width: width,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black),
                                                                    color:
                                                                    Colors.green),
                                                                child: Center(
                                                                  child: Text(
                                                                    add==false?"Join ":" Add "
                                                                        .toUpperCase(),
                                                                    style: GoogleFonts.lato(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                        fontSize: 16),
                                                                  ),
                                                                )),
                                                          ),
                                                        ),
                                                      )
                                                          : SpinKitThreeInOut(
                                                        color: Colors.white,
                                                        size: 20,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]
                                        )
                                    ))): Text('No data');
                          }
                      }
                      return CircularProgressIndicator();
                    })),
          ],
        ),
      ),
    );
  }
  Widget buildRadios() => Row(
    children: due.map(
          (value) {
        final selected = this.selectedValue == value;

        return Expanded(
          child: RadioListTile<String>(
              value: value,
              groupValue: selectedValue,
              title: Text(
                value,
              ),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  selected_country = value;

                });
                print(selectedValue);
              }),
        );
      },
    ).toList(),
  );
  Widget buildRadios2() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: Squadg.map(
            (value) {
          final selected = this.selectedValuesquad == value;

          return Expanded(
            child: RadioListTile<String>(
                contentPadding: EdgeInsets.only(left: 0),
                dense: true,


                value: value,
                groupValue: selectedValuesquad,
                title: Text(
                  value,style: TextStyle(
                    fontSize: 10
                ),
                ),
                onChanged: (value) {
                  setState((){
                    selectedValuesquad=value;
                    selected_country = value;
                  }
                  );
                  print(selected_country);
                }),
          );
        },
      ).toList(),
    ),
  );
}
