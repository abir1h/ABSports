import 'dart:convert';
import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/Play.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/me.dart';
import 'package:sports_club/Screens/MainHome/Bottom_nav_menues/shop.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ota_update/ota_update.dart';

import '../Update_app.dart';
import 'Bottom_nav_menues/store.dart';
import 'me/my_wallet.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  OtaEvent currentEvent;
  TabController _controllertab;

  int _selectedIndex = 2;
  List<Widget> _widgetOptions = <Widget>[
    store(),
    shop(),
    play(),
    me(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
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
  var telegram_link;
  Future telegram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.telegram), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['link']);
      setState(() {
        telegram_link = userData1['link'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  var p_id;
  get_playerd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String player_id = prefs.getString('player_ID');
    setState(() {
      p_id = player_id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    telegram();
    get_playerd();
    _controllertab = new TabController(length: 4, vsync: this);
badge();
    getversion();
    status_();
  }

  var version;
  getversion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version_ = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      version = version_;
    });
  }
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
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text("Are you sure you want to exit?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("YES"),
                      onPressed: () {
                        exit(0);
                      },
                    ),
                    FlatButton(
                      child: Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false, // Don't show the leading button

              backgroundColor: Colors.white,

              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProfileAvatar(null,
                      borderColor: Colors.transparent,
                      child:Image.asset("Images/l.jpeg"),
                      elevation: 5,
                      radius: 24),                  Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.white,
                    child: InkWell(
                      onTap: () {
                        // tryOtaUpdate();
                        print('tiamo');
                        print(version);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:InkWell(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (_)=>update_app()));
                              },
                              child:  Text("AB ESPORTS".toUpperCase(),
                                  style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Your widgets here
                ],
              ),
              actions: [
                InkWell(
                    onTap: () {
                      status==0?Navigator.push(context,
                          MaterialPageRoute(builder: (_) => my_wallet())):null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'Images/i.png',
                        height: 50,
                        width: 50,
                      ),
                    ))
              ],
            ),

            // floatingActionButton: FloatingActionButton(
            //   backgroundColor: Color(0xff0084FF),
            //   onPressed: () async {
            //     var url = telegram_link;
            //     if (await canLaunch(url))
            //       await launch(url);
            //     else
            //       // can't launch url, there is some error
            //       throw "Could not launch $url";
            //   },
            //   child: Image.asset(
            //     'Images/messenger.png',
            //     height: 30,
            //     width: 30,
            //   ),
            // ),
            body: Column(
              children: [
                status==0?   Container(
                  height: height / 1.2,
                  child: TabBarView(

                    controller: _controllertab,
                    children: [
                      play(text_: badge_text!=null?badge_text:'ABsports',),
                      shop(),
store(),                      me(),
                    ],
                  ),
                ):Container(
                  height: height / 1.2,
                  child: TabBarView(

                    controller: _controllertab,
                    children: [
                      play(text_: badge_text!=null?badge_text:'ABsports',),
                      play(text_: badge_text!=null?badge_text:'ABsports'),
                      play(text_: badge_text!=null?badge_text:'ABsports',)    ,             play(text_: badge_text!=null?badge_text:'ABsports',)
                    ],
                  ),
                ),
                TabBar(
                  controller: _controllertab,
                  isScrollable: true,
                  indicatorColor: Colors.black,
                  tabs: [
                    // Tab(icon: Icon(Icons.flight,color: Colors.black,)),
                    Tab(
                      child: Container(
                          width: 60,
                          child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.blue,
                            child: FaIcon(FontAwesomeIcons.gamepad),
                          )),
                    ),
                    Tab(
                      child: Container(
                        width: 60,
                        child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.blue,
                            child: Icon(
                              Icons.video_collection,
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 60,
                        child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.blue,
                            child: Icon(
                              Icons.store,
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: 60,
                        child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            )

            // bottomNavigationBar: BottomNavigationBar(
            //   backgroundColor:  Colors.white,
            //   iconSize: 20,
            //
            //   unselectedItemColor: Colors.grey,
            //   selectedItemColor: Colors.black,
            //
            //
            //
            //   items: const <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //       icon:Icon(Icons.video_collection),
            //       label: 'Videos',
            //
            //       backgroundColor: Color(0xFF06031E),
            //     ),BottomNavigationBarItem(
            //       icon:FaIcon(FontAwesomeIcons.gamepad),
            //       label: 'Play',
            //       backgroundColor: Color(0xFF06031E),
            //     ),BottomNavigationBarItem(
            //       icon:  Icon(
            //         Icons.person,
            //       ),
            //       label: 'Profile',
            //       backgroundColor: Color(0xFF06031E),
            //     ),
            //   ],
            //   currentIndex: _selectedIndex,
            //   onTap: _onItemTap,
            //   selectedLabelStyle: TextStyle(color: Color(0xFF06031E)),
            //   unselectedLabelStyle: TextStyle(color: Color(0xFF06031E)),
            //   showSelectedLabels: true,
            //   showUnselectedLabels: true,
            //
            //   selectedFontSize: 16.0,
            //   unselectedFontSize: 12.0,
            // ),
            // bottomNavigationBar: CurvedNavigationBar(
            //   key: _bottomNavigationKey,
            //   index: 2,
            //   height: 60.0,
            //   items: <Widget>[
            //     Shimmer.fromColors(
            //         baseColor: Colors.black,
            //         highlightColor: Colors.blue,
            //         child: Icon(Icons.store)), Shimmer.fromColors(
            //         baseColor: Colors.black,
            //         highlightColor: Colors.blue,
            //         child: Icon(Icons.video_collection)),
            //     Shimmer.fromColors(
            //         baseColor: Colors.black,
            //         highlightColor: Colors.blue,
            //         child: FaIcon(FontAwesomeIcons.gamepad)),
            //     Shimmer.fromColors(
            //         baseColor: Colors.black,
            //         highlightColor: Colors.blue,
            //         child: Icon(
            //           Icons.person,
            //         )),
            //   ],
            //   color: Colors.white,
            //   buttonBackgroundColor: Colors.white,
            //   backgroundColor: Colors.black,
            //   animationCurve: Curves.easeInOut,
            //   animationDuration: Duration(milliseconds: 600),
            //   onTap: (index) {
            //     _onItemTap(index);
            //   },
            // ),
            ));
  }
}
