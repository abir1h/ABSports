import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';

import '../mainHome.dart';
import 'depostie.dart';
class purchased extends StatefulWidget {
  @override
  _purchasedState createState() => _purchasedState();
}

class _purchasedState extends State<purchased> {
  Future slide;
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(AppUrl.purchased), headers: requestHeaders);
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
    return Scaffold(
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
        title: Text("Purchase History",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),

      body: SingleChildScrollView(

        child: Container(

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
                                  ?      snapshot.data.length>0?                              Container(
                                height: MediaQuery.of(context).size.height/1.2,

                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_,index){
                                      return Column(
                                        children: [
                                          ListTile(leading:Text('💎',style: TextStyle(
                                            fontSize: 24
                                          ),),


                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Price : ",style:  GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16
                                                ),),
Text("৳"+snapshot.data[index]['price'].toString(),style:  GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16
                                                ),),

                                              ],
                                            ),

                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Diamond Amount" ,style:  GoogleFonts.lato(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    )),
                                                    snapshot.data[index]['diamond_amount']!=null?  Text(snapshot.data[index]['diamond_amount'],style:  GoogleFonts.lato(
                                                        color: Colors.orange,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    )):Text("N/A")
                                                  ],
                                                ),Row(
                                                  children: [
                                                    Text("Type " ,style:  GoogleFonts.lato(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    )),Text(snapshot.data[index]['title'],style:  GoogleFonts.lato(
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(color: Colors.black54,)
                                        ],
                                      );
                                    }),
                              ):
                              Center(child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height/5,),
                                  Image.asset('Images/em.gif',height: MediaQuery.of(context).size.height/4,),
                                  Text("No Transaction Found!! " ,style:  GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  )),SizedBox(height: 10,),
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (_) =>             deposite()));
                                    },
                                    child: Text("Add Coins " ,style:  GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16
                                    )),
                                  )
                                ],
                              ))



                                  : Text('No data');
                            }
                        }
                        return CircularProgressIndicator();
                      })),

            ],
          ),
        ),
      ),
    );
  }
}
