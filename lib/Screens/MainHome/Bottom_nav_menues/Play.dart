import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../new_page.dart';

class play extends StatefulWidget {
  final String text_;
  play({this.text_});
  @override
  _playState createState() => _playState();
}

class _playState extends State<play> {

  Future status_() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.maintanence),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('niceto');
      print(userData1['status2']);
      setState(() {
        status=userData1['status2'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var status;
  Future slide;
  func() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);
  }

  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.slider), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Future count;
  var g; var badge_text;
  Future badge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.notice), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print('try');
      print(userData1);
      setState(() {
        badge_text=userData1['notice'];
      });

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Future count_match() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.count), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['p']);
      print(userData1['f']);
      setState(() {
        p = userData1['p'];
        f = userData1['f'];
        cs = userData1['a'];
        classic = userData1['b'];
        ludu = userData1['l'];
        g = userData1['g'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
var ludu;
  var cs, classic;
  Timer notification_timer;
  @override
  void dispose() {
    // TODO: implement dispose
    notification_timer.cancel();

    super.dispose();
  }

  var f, p;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slide = emergency();
    count = count_match();
    func();
    notification_timer =
        Timer.periodic(Duration(seconds: 15), (_) => count = count_match());
    status_();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Container(
            width: width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Images/lg2.png'), fit: BoxFit.cover)),
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
                                    ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          height:
                                              MediaQuery.of(context).size.height /
                                                  5.5,
                                          child: CarouselSlider.builder(
                                            options: CarouselOptions(
                                              scrollDirection: Axis.horizontal,
                                              scrollPhysics:
                                                  AlwaysScrollableScrollPhysics(),
                                              height: 200,
                                              autoPlay: true,
                                              autoPlayCurve: Curves.easeInOut,
                                              reverse: true,
                                              enlargeCenterPage: true,
                                              viewportFraction: 0.7,
                                            ),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext context,
                                                    int itemIndex,
                                                    int pageViewIndex) =>
                                                Container(
                                                    height: height / 5,
                                                    width: width / 1,
                                                    child: InkWell(
                                                        onTap: () async {
                                                          var url = snapshot
                                                                  .data[itemIndex]
                                                              ['links'];
                                                          if (await canLaunch(
                                                              url))
                                                            await launch(url);
                                                          else
                                                            // can't launch url, there is some error
                                                            throw "Could not launch $url";
                                                        },
                                                        child: Container(
                                                            child: Image.network(
                                                          AppUrl.pic_url1 +
                                                              snapshot.data[
                                                                      itemIndex]
                                                                  ['images'],
                                                          fit: BoxFit.cover,
                                                        )))),
                                          ),
                                        ),
                                      )
                                    : Text('No data');
                              }
                          }
                          return CircularProgressIndicator();
                        })),
                Container(
                  height:height/25,
                  width: width,
                  decoration: BoxDecoration(
                    color:  Color(0xFF2C3249),
                  ),
                  child :Marquee(
                    text: widget.text_!=null?widget.text_:' ',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 20.0,
                    velocity: 50.0,
                    pauseAfterRound: Duration(seconds: 1),
                    startPadding: 5.0,
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),

                Center(
                    child: Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.blue,
                  child: Text("Daily Matches Free Fire",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      )),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: width / 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // p!=0? Navigator.push(context, MaterialPageRoute(builder: (_)=>Appointments(type: 'p',))): Fluttertoast.showToast(
                                      //
                                      //     msg: "No matches found!!",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 2,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);

                                      status==0? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Appointments(
                                                image: 'Images/c.jpeg',

                                                type: 'p',
                                                  ))):null;
                                    },
                                    child: Container(
                                      height: height / 6.8,
                                      width: width / 2,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: AssetImage('Images/cs.jpeg'),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircularProfileAvatar(null,
                                                child: Image.asset(
                                                  "Images/c.jpeg",
                                                  fit: BoxFit.cover,
                                                ),
                                                elevation: 5,
                                                radius: 20),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("CS Free fire",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.transparent,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14)),
                                            ),                                            SizedBox(height:15),

                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: p == 0
                                                    ? Text("0 Matches Found",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14))
                                                    : Text(
                                                        p != null
                                                            ? "$p Matches Found"
                                                            : ".. Matches Found ",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // f==0? Fluttertoast.showToast(
                                      //
                                      //     msg: "No matches found!!",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0):  Navigator.push(context, MaterialPageRoute(builder: (_)=>Appointments(type: 'f',)));
                                      status==0?  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Appointments(
                                                image: 'Images/c.jpeg',
                                                    type: 'f',
                                                  ))):null;
                                    },
                                    child: Container(
                                      height: height / 6.8,
                                      width: width / 2,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: AssetImage('Images/br.jpeg'),
                                              fit: BoxFit.cover
                                          )

                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircularProfileAvatar(null,
                                                child: Image.asset(
                                                  "Images/c.jpeg",
                                                  fit: BoxFit.cover,
                                                ),
                                                elevation: 5,
                                                radius: 20),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("Classic Free Fire",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.transparent,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14)),
                                            ),
                                            SizedBox(height:15),                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: f == 0
                                                    ? Text("0 Matches Found",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14))
                                                    : Text(
                                                        f != null
                                                            ? "$f Matches Found"
                                                            : ".. Matches Found ",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14)))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.blue,
                      child: Text("Grand Matchs & Others",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                          )),
                    )),

                // Center(
                //     child: Shimmer.fromColors(
                //   baseColor: Colors.black,
                //   highlightColor: Colors.blue,
                //   child: Text("Daily Matches PUBG ",
                //       style: GoogleFonts.lato(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w800,
                //         color: Colors.grey,
                //       )),
                // )),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: width / 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // classic==0? Fluttertoast.showToast(
                                      //
                                      //     msg: "No matches found!!",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0):
                                      status==0?    Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Appointments(
                                                image: 'Images/c.jpeg',

                                                type: 'g',
                                              ))):null;
                                    },
                                    child: Container(
                                      height: height / 6.8,
                                      width: width / 2,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue,
                                          image: DecorationImage(
                                              image: AssetImage('Images/pi.jpeg'),
                                              fit: BoxFit.cover
                                          )


                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircularProfileAvatar(null,
                                                child: Image.asset(
                                                  "Images/c.jpeg",
                                                  fit: BoxFit.cover,
                                                ),
                                                elevation: 5,
                                                radius: 20),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Shimmer.fromColors(
                                                        baseColor: Colors.white,
                                                        highlightColor: Colors.blue,
                                                        child: Text("Grand Match",
                                                            style: GoogleFonts.lato(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                fontSize: 20)),
                                                      )
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0),
                                                    child: g == 0
                                                        ?  Text("0 Matches Found",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 14))
                                                        :  Text(
                                                        g != null
                                                            ? "$g Matches Found"
                                                            : ".. Matches Found ",
                                                        style: GoogleFonts.lato(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 14)),
                                                  )
                                                ],
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Center(
                          //     child: Shimmer.fromColors(
                          //       baseColor: Colors.black,
                          //       highlightColor: Colors.blue,
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(top:2.0),
                          //         child: Text("Daily Matches Ludo",
                          //             style: GoogleFonts.lato(
                          //               fontSize: 18,
                          //               fontWeight: FontWeight.w800,
                          //               color: Colors.grey,
                          //             )),
                          //       ),
                          //     )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 8.0,
                                    top: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // classic==0? Fluttertoast.showToast(
                                      //
                                      //     msg: "No matches found!!",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0):
                                      status==0?   Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Appointments(
                                                image: 'Images/l.jpg',

                                                type: 'l',
                                              ))):null;
                                    },
                                    child: Container(
                                      height: height / 6.8,
                                      width: width / 2,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.blue,
                                        image: DecorationImage(
                                          image: AssetImage('Images/r.jpeg'),
                                          fit: BoxFit.cover
                                        )


                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            CircularProfileAvatar(null,
                                                child: CircularProfileAvatar(null,
                                                    child: Image.asset(
                                                      "Images/l.jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    elevation: 5,
                                                    radius: 20),
                                                elevation: 5,
                                                radius: 20),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Shimmer.fromColors(child: Text(" LUDO",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 16)),  baseColor: Colors.white,
                                                highlightColor: Colors.blue,)
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: ludu == 0
                                                  ? Text("0 Matches Found",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 14))
                                                  :  Text(
                                                  ludu != null
                                                      ? "$ludu Matches Found"
                                                      : ".. Matches Found ",
                                                  style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 14)),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
                // Align(child: Image.asset('Images/logo1.png',height: MediaQuery.of(context).size.height/18,)),
              ],
            ),
          ),
        ));
  }
}
