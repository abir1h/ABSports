import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import '../mainHome.dart';
class Sticky {
  static List color = [
    const Color(0xffB85252),
    const Color(0xffB4C6A6),
    // const Color(0xff346751),
    // const Color(0xffFFC947),
    const Color(0xff3282B8),
  ];


  static Color getColorItem() =>
      (color.toList()
        ..shuffle()).first;
}

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {

  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.leaderboard), headers: requestHeaders);
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
    slide=emergency();

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF07031E),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          },
        ),
        title: InkWell(
          onTap: () {
          },
          child: Text("LeaderBoard",
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("All Time Best ",
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25)),
            ),
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
                                ?      snapshot.data.length>0?
                              Container(
                              height: height/1.3,
                              child: ListView.builder(

                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,

                                  itemBuilder: (_,index){
                                    var index_of=index+1;
                                return             Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: height/15,
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Sticky.getColorItem(),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height/14,
                                              width: MediaQuery.of(context).size.width/9,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  image: DecorationImage(
                                                      image:  NetworkImage(
                                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkIq9DjIgYbGgIenjkjA-tkr3mN1_bBnsEw&usqp=CAU',
                                                      ),
                                                      fit: BoxFit.cover

                                                  )
                                              ),
                                            ),
                                          ),
                                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10,),
                                              Text(snapshot.data[index]['first_name'],
                                                  style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18)), Text("Most Kills - "+snapshot.data[index]['kills'].toString(),
                                                  style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Text("Rank - $index_of",
                                                style: GoogleFonts.lato(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                );

                              }),
                            ):
                            Center(child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height/5,),
                                Image.asset('Images/em.gif',height: MediaQuery.of(context).size.height/4,),

                              ],
                            ))



                                : Text('No data');
                          }
                      }
                      return CircularProgressIndicator();
                    })),

          //   Container(
          //   height: height/1.3,
          //   child: ListView.builder(
          //
          //       itemCount: 20,
          //       shrinkWrap: true,
          //
          //       itemBuilder: (_,index){
          //     return             Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Container(
          //         height: height/15,
          //         width: width,
          //         decoration: BoxDecoration(
          //             color: Sticky.getColorItem(),
          //             borderRadius: BorderRadius.circular(10)
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Row(children: [
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Container(
          //                   height: MediaQuery.of(context).size.height/14,
          //                   width: MediaQuery.of(context).size.width/9,
          //                   decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(5),
          //                       image: DecorationImage(
          //                           image:  NetworkImage(
          //                             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkIq9DjIgYbGgIenjkjA-tkr3mN1_bBnsEw&usqp=CAU',
          //                           ),
          //                           fit: BoxFit.cover
          //
          //                       )
          //                   ),
          //                 ),
          //               ),
          //               Column(crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   SizedBox(height: 10,),
          //                   Text("Abir Rahman",
          //                       style: GoogleFonts.lato(
          //                           color: Colors.white,
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 18)), Text("Most Kills -  5",
          //                       style: GoogleFonts.lato(
          //                           color: Colors.white,
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 12)),
          //                 ],
          //               ),
          //             ],),
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Container(
          //                 child: Text("Rank - 1",
          //                     style: GoogleFonts.lato(
          //                         color: Colors.white,
          //                         fontWeight: FontWeight.w700,
          //                         fontSize: 20)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ),
          //
          //     );
          //
          //   }),
          // )
          ],
        ),
      ),
    ));
  }
}
