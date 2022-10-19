import 'dart:async';
import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Join_match.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Room_details.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/Roome_ng.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/prize_details.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/quad_join.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/roome_details_popup.dart';

import 'package:http/http.dart' as http;
import 'package:sports_club/Screens/MainHome/Daily_matches/solo_join_match.dart';

import '../../join_match_2.dart';
import 'Room_details_cs.dart';
import 'join_duo.dart';

class Daily_matces_clash_squad_free extends StatefulWidget {
  final String type,image;
  Daily_matces_clash_squad_free({this.type,this.image});
  @override
  _Daily_matces_clash_squad_freeState createState() =>
      _Daily_matces_clash_squad_freeState();
}

class _Daily_matces_clash_squad_freeState
    extends State<Daily_matces_clash_squad_free> {
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.gamelist + widget.type),
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

  Timer notification_timer;

  double progress;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      slide = emergency();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      slide = emergency();
    });
    if (mounted)
      setState(() {
        slide = emergency();
      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slide = emergency();
    // notification_timer=Timer.periodic(Duration(seconds: 10), (_) =>  slide=emergency());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // notification_timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  constraints: BoxConstraints(),
                  child: FutureBuilder(
                      future: slide,
                      builder: (_, AsyncSnapshot snapshot) {
                        print(snapshot.data);
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[100],
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (_, __) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 48.0,
                                          height: 48.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 8.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  itemCount: 6,
                                ),
                              ),
                            );
                          default:
                            if (snapshot.hasError) {
                              Text('Error: ${snapshot.error}');
                            } else {
                              return snapshot.hasData
                                  ? snapshot.data.length > 0
                                      ? Container(
                                          height: height / 1.2,
                                          child: SmartRefresher(
                                            enablePullDown: true,
                                            enablePullUp: false,
                                            header: WaterDropHeader(),
                                            footer: CustomFooter(
                                              builder: (BuildContext context,
                                                  LoadStatus mode) {
                                                Widget body;
                                                if (mode == LoadStatus.idle) {
                                                  body = Text("pull up load");
                                                } else if (mode ==
                                                    LoadStatus.loading) {
                                                  body =
                                                      CupertinoActivityIndicator();
                                                } else if (mode ==
                                                    LoadStatus.failed) {
                                                  body = Text(
                                                      "Load Failed!Click retry!");
                                                } else if (mode ==
                                                    LoadStatus.canLoading) {
                                                  body = Text(
                                                      "release to load more");
                                                } else {
                                                  body = Text("No more Data");
                                                }
                                                return Container(
                                                  height: 55.0,
                                                  child: Center(child: body),
                                                );
                                              },
                                            ),
                                            controller: _refreshController,
                                            onRefresh: _onRefresh,
                                            onLoading: _onLoading,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (_, index) {
                                                  progress = double.parse(
                                                      snapshot.data[index][
                                                          'total_participant']);

                                                  var total = int.parse(snapshot
                                                          .data[index]
                                                      ['total_participant']);
                                                  var game =
                                                      snapshot.data[index]
                                                          ['game_player_count'];
                                                  var left_ = total - game;
                                                  var _percentages =
                                                      (game / total);

                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            widget.type=='p'?
                                                            Navigator.push(context, MaterialPageRoute(builder: (_)=>room_Details_cs(id: snapshot.data[index]['id'].toString() ,)))
                                                                :Navigator.push(
                                                                context, MaterialPageRoute(builder: (_) => room_Details(id: snapshot.data[index]['id'].toString(),)));
                                                          },
                                                          child: Container(
                                                            width: width / 1,
                                                            decoration: BoxDecoration(
                                                                color: Color(0xFF70cdff),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                CircularProfileAvatar(null,
                                                                                    borderColor: Colors.transparent,
                                                                                    child: Image.asset(
                                                                                      widget.image,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                    elevation: 5,
                                                                                    radius: 30),
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(snapshot.data[index]['title'] + ' | ' + snapshot.data[index]['control_type'] + ' | ' + snapshot.data[index]['game_id'],
                                                                                              style: GoogleFonts.lato(
                                                                                                color: Colors.white,
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w600,
                                                                                              )),
                                                                                          Row(
                                                                                            children: [
                                                                                              Text('Time : ' + snapshot.data[index]['date'],
                                                                                                  style: GoogleFonts.lato(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 16,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                  )),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Total Prize', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                              Row(                                                                      mainAxisAlignment:MainAxisAlignment.center,

                                                                                children: [
                                                                                  Image.asset('Images/t.png',height: 25,width: 25,),

                                                                                  Text('  ' + snapshot.data[index]['total_prize'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Per Kill', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                              Row(                                                                      mainAxisAlignment:MainAxisAlignment.center,

                                                                                children: [
                                                                                  Image.asset('Images/t.png',height: 25,width: 25,),

                                                                                  Text('  ' + snapshot.data[index]['per_kill'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Entry Fee', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                              Row(                                                                      mainAxisAlignment:MainAxisAlignment.center,

                                                                                children: [                                                                        Image.asset('Images/t.png',height: 25,width: 25,),

                                                                                  Text('  ' + snapshot.data[index]['entry_fee'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Type', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                              Text(snapshot.data[index]['type'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Version', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                              Text(snapshot.data[index]['version'], style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text('Map', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                              Text(snapshot.data[index]['map']!=null?snapshot.data[index]['map']:'N?A', style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              LinearProgressIndicator(
                                                                                value: _percentages,
                                                                                backgroundColor: Colors.grey,
                                                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                                                                              ),
                                                                              Container(
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    game != total
                                                                                        ? Container(
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Text(
                                                                                                  "Only " + left_.toString() + " spots left",
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontWeight: FontWeight.normal,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        : Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Text(
                                                                                              "No spots Left",
                                                                                              style: TextStyle(
                                                                                                color: Colors.red,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                    game != total
                                                                                        ? Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Text(
                                                                                              game.toString() + ' / ' + total.toString(),
                                                                                              style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Text(
                                                                                              game.toString() + ' / ' + total.toString(),
                                                                                              style: TextStyle(
                                                                                                color: Colors.red,
                                                                                                fontWeight: FontWeight.normal,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: game !=
                                                                                total
                                                                            ? snapshot.data[index]['game_player_have'] == 0
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                      widget.type=='p'? Navigator.push(
                                                                                          context, MaterialPageRoute(builder: (_) => join_match_2(id: snapshot.data[index]['id'].toString(),type: int.parse(snapshot.data[index]['type']),)))
                                                                                          :snapshot.data[index]['type']=='Solo'?Navigator.push(
                                                                                          context, MaterialPageRoute(builder: (_) => solo_join(id: snapshot.data[index]['id'].toString(),))):snapshot.data[index]['type']=='Duo'?Navigator.push(
                                                                                          context, MaterialPageRoute(builder: (_) => join_duo(id: snapshot.data[index]['id'].toString(),))):Navigator.push(
                                                                                          context, MaterialPageRoute(builder: (_) => squad_join(id: snapshot.data[index]['id'].toString(),)));
                                                                                    },
                                                                                    child: Container(
                                                                                        width: width / 6,
                                                                                        height: height / 25,
                                                                                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue, width: 2)),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Join",
                                                                                            style: TextStyle(
                                                                                              color: Colors.blue,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        )),
                                                                                  )
                                                                                : InkWell(
                                                                                    onTap: () {
                                                                                      Fluttertoast.showToast(msg: "Already Joined", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black54, textColor: Colors.white, fontSize: 16.0);
                                                                                    },
                                                                                    child: Container(
                                                                                        width: width / 6,
                                                                                        height: height / 25,
                                                                                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue, width: 2)),
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Joined",
                                                                                            style: TextStyle(
                                                                                              color: Colors.blue,
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        )),
                                                                                  )
                                                                            : Container(
                                                                                width: width / 4,
                                                                                height: height / 25,
                                                                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.blue, width: 2)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    " Match Full",
                                                                                    style: TextStyle(
                                                                                      color: Colors.blue,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: Container(
                                                                              child: ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              snapshot.data[index]['game_player_have'] == 0
                                                                                  ? showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return Roome_ng();
                                                                                      })
                                                                                  : showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return room_details_pop(
                                                                                          id: snapshot.data[index]['id'].toString(),
                                                                                        );
                                                                                      });
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.white, //background color of button
                                                                              side: BorderSide(width: 3, color: Colors.blue), //border width and color
                                                                              elevation: 3, //elevation of button
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "Room Details",
                                                                              style: TextStyle(
                                                                                color: Colors.blue,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: Container(
                                                                              child: ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return prize_details(
                                                                                      id: snapshot.data[index]['id'].toString(),
                                                                                    );
                                                                                  });
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              primary: Colors.white, //background color of button
                                                                              side: BorderSide(width: 3, color: Colors.blue), //border width and color
                                                                              elevation: 3, //elevation of button
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "Total Prize Details",
                                                                              style: TextStyle(
                                                                                color: Colors.blue,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        )
                                      : Center(
                                          child: Column(
                                          children: [
                                            SizedBox(
                                              height: height / 5,
                                            ),
                                            Image.asset(
                                              'Images/gt.gif',
                                              height: height / 4,
                                            ),
                                          ],
                                        ))
                                  : Text('No data');
                            }
                        }
                        return CircularProgressIndicator();
                      })),
            ],
          ),
        ));
  }
}
