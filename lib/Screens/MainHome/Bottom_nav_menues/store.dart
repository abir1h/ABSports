
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shimmer/shimmer.dart';

import 'package:http/http.dart'as http;
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/Daily_matches/checkout.dart';
import 'package:sports_club/Screens/MainHome/me/depostie.dart';

import '../mainHome.dart';

class store extends StatefulWidget {
  @override
  _storeState createState() => _storeState();
}

class _storeState extends State<store> {
  var balance_ammount, match_played, total_kills, paid;
  Future details() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response =
    await http.get(Uri.parse(AppUrl.match_count), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      print(userData1['matchCount']);
      setState(() {
        match_played = userData1['matchCount'];
        total_kills = userData1['killCount'];
        paid = userData1['deposit'];
        balance_ammount = userData1['balance'];
      });
      slide=emergency();

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.shop2), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    details();
  }
  Future withdraw(String title,String prics,String diamond_ammount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.checkout),
    );
    request.fields.addAll({
      'title': title,
      'price': prics,
      'diamond_amount': diamond_ammount,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {

          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MainHome()));
          Fluttertoast.showToast(
              msg: "Diamond Purchased  Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {

          print("Fail! ");
          print(response.body.toString());
          Fluttertoast.showToast(
              msg: "Error Occured",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;
        }
      });
    });
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

              // Container(
              //     constraints: BoxConstraints(),
              //     child: FutureBuilder(
              //         future: slide,
              //         builder: (_, AsyncSnapshot snapshot) {
              //           print(snapshot.data);
              //           switch (snapshot.connectionState) {
              //             case ConnectionState.waiting:
              //               return  SizedBox(
              //                 width: MediaQuery.of(context).size.width,
              //                 height: MediaQuery.of(context).size.height/5,
              //
              //                 child: SpinKitThreeInOut(color: Colors.white,size: 20,),
              //               );
              //             default:
              //               if (snapshot.hasError) {
              //                 Text('Error: ${snapshot.error}');
              //               } else {
              //                 return snapshot.hasData
              //                     ?                          Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Container(
              //                   height: MediaQuery.of(context).size.height/1,
              //                   child: ListView.builder(
              //                       itemBuilder: (context,index){}),
              //                 ),
              //                     )
              //
              //
              //                     : Text('No data');
              //               }
              //           }
              //           return CircularProgressIndicator();
              //         })),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Column(
              //     children: [
              //       Container(
              //         height: MediaQuery.of(context).size.height/1,
              //         child: ListView.builder(
              //             itemCount: 10,
              //             itemBuilder: (context,index){
              //               return Column(
              //                 children: [
              //                   Row(
              //                     children: [
              //                       Shimmer.fromColors(
              //                         baseColor: Colors.red,
              //                         highlightColor: Color(0xFFFFD700),
              //                         child: IconButton(
              //                             icon: const Icon(Icons.video_library),
              //                             onPressed: (){
              //
              //                             }
              //                         ),
              //                       ),
              //                       Shimmer.fromColors(
              //                         baseColor: Colors.black,
              //                         highlightColor: Color(0xFFFFD700),
              //                         child: Text("  Video Title".toUpperCase(),
              //                             style: GoogleFonts.lato(
              //                                 color: Colors.white,
              //                                 fontWeight: FontWeight.w800,
              //                                 fontSize: 14)),
              //                       ),
              //                     ],
              //                   ),
              //
              //                   InkWell(
              //                     onTap:(){
              //                       Navigator.push(context, MaterialPageRoute(builder: (_)=>open_video(link: 'https://youtu.be/wIhn7w0vg50',)));
              //                     },
              //                     child: Container(
              //                       height: height/4,
              //                       width: width,
              //                       decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(15),
              //                           image: DecorationImage(
              //                               image: NetworkImage('https://i.pinimg.com/originals/1c/94/48/1c9448b3da039136b912247c4a68a54a.jpg'),
              //                               fit: BoxFit.cover
              //                           )
              //
              //                       ),),
              //                   ),
              //
              //
              //                   SizedBox(height: 10,)
              //
              //                 ],
              //               );
              //             }),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height:15),
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
                                  ?                                       Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height/1.4                                                                                                                                                                        ,
                                  child: GridView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 240,
                                          childAspectRatio: 3/3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                      itemCount:snapshot.data.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return InkWell(
                                            onTap: ()async{
                                              // if (await canLaunch(url))
                                              //   await launch(url);
                                              // else
                                              //   // can't launch url, there is some error
                                              //   throw "Could not launch $url";
                                            },
                                            child:  Container(
                                              height: height/7,
                                              width: width/2.4,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.2),

                                                      spreadRadius: 2,

                                                      blurRadius: 5,

                                                      offset: Offset(
                                                          0, 4), // changes position of shadow
                                                    ),
                                                  ],
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.white),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(child: Image.network( AppUrl.pic_url1 +
                                                      snapshot.data[
                                                      index]
                                                      ['thumbnail'],height: 80,width:width)),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(snapshot.data[index]['title'],
                                                        style: GoogleFonts.lato(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [                                                                        Image.asset('Images/t.png',height: 25,width: 25,),

                                                            Text(' '+snapshot.data[index]['price'],
                                                                style: GoogleFonts.lato(
                                                                  color: Colors.orange,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600,)),
                                                          ],
                                                        ),Text('Diamonds ' + snapshot.data[index]['diamond_amount'],
                                                            style: GoogleFonts.lato(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600,)),
                                                      ],
                                                    ),
                                                  ),
                                                  balance_ammount<int.parse(snapshot.data[index]['price'])?  Align(
                                                    alignment:Alignment.topRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right:8.0),
                                                      child: InkWell(
                                                        onTap: (){
Navigator.push(context, MaterialPageRoute(builder: (_)=>deposite()));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.blue,
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text("Deposit First",style: TextStyle(
                                                                color: Colors.white,fontWeight: FontWeight.bold
                                                            ),),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ): Align(
                                                    alignment:Alignment.topRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right:8.0),
                                                      child: InkWell(
                                                        onTap: (){
                                                          balance_ammount<int.parse(snapshot.data[index]['price'])?     Fluttertoast.showToast(
                                                              msg: "Insufficient Balance",
                                                              toastLength: Toast.LENGTH_LONG,
                                                              gravity: ToastGravity.CENTER,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.black,
                                                              textColor: Colors.black,
                                                              fontSize: 16.0):
                                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>check_out(title:snapshot.data[index]['title'] ,price: snapshot.data[index]['price'].toString(),diamon_amount:snapshot.data[index]['diamond_amount'].toString() , image: snapshot.data[
                                                          index]
                                                          ['thumbnail'].toString())));

                                                          print(int.parse(snapshot.data[index]['price']));
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.blue,
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text("Buy Now",style: TextStyle(
                                                                color: Colors.white,fontWeight: FontWeight.bold
                                                            ),),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                        );
                                      }),
                                ),
                              )



                                  : Center(child: CircularProgressIndicator());
                            }
                        }
                        return CircularProgressIndicator();
                      })),

            ],
          ),
        ));
  }
}
