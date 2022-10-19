import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/open_video.dart';


class shop extends StatefulWidget {
  @override
  _shopState createState() => _shopState();
}

class _shopState extends State<shop> {
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
        await http.get(Uri.parse(AppUrl.Show_video), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  views_hit(String video_id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.view+video_id),
    );
    // request.fields.addAll({
    //
    // });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
         print('Success');
         print(response.body);
        } else {
          print('Fail');
          print(response.body);

        }
      });
    });
  }
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
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
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
                              return  SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/5,

                                child: SpinKitThreeInOut(color: Colors.white,size: 20,),
                              );
                            default:
                              if (snapshot.hasError) {
                                Text('Error: ${snapshot.error}');
                              } else {
                                return snapshot.hasData
                                    ?      Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height/1.3,
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
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context,index){
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Shimmer.fromColors(
                                                          baseColor: Colors.blue,
                                                          highlightColor:Colors.blue,
                                                          child: IconButton(
                                                              icon: const Icon(Icons.video_library,color: Colors.blue,),
                                                              onPressed: (){

                                                              }
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Shimmer.fromColors(
                                                            baseColor: Colors.black,
                                                            highlightColor:Colors.blue,
                                                            child: Text(" "+ snapshot.data[index]['title'].toUpperCase(),
                                                                style: GoogleFonts.lato(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w800,
                                                                    fontSize: 14)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    InkWell(
                                                      onTap:(){
                                                        views_hit(snapshot.data[index]['id'].toString());
                                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>open_video(link: snapshot.data[index]['link']
                                                          ,id:snapshot.data[index]['id'].toString() ,
                                                          views: snapshot.data[index]['views'],
                                                          title: snapshot.data[index]['title']


                                                        )));
                                                      },
                                                      child: Container(
                                                        height: height/4,
                                                        width: width,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15),
                                                            image: DecorationImage(
                                                                image: NetworkImage(AppUrl.pic_url1+snapshot.data[index]['thumbnail']),
                                                                fit: BoxFit.cover
                                                            )

                                                        ),),
                                                    ),


                                                    SizedBox(height: 10,)

                                                  ],
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                )


                                    : Text('No data');
                              }
                          }
                          return CircularProgressIndicator();
                        })),


                // Center(
                //   child: Column(
                //     children: [
                //       SizedBox(
                //         height: height / 3,
                //       ),
                //       Shimmer.fromColors(
                //         baseColor: Colors.black,
                //         highlightColor:Colors.blue,
                //         child: Text("Comming Soon".toUpperCase(),
                //             style: GoogleFonts.lato(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w800,
                //                 fontSize: 20)),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )),
    );
  }
}
