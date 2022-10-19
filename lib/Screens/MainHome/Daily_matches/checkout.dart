import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:http/http.dart'as http;

import '../mainHome.dart';
class check_out extends StatefulWidget {
  final String title,price,diamon_amount,image;
  check_out({this.title,this.price,this.diamon_amount,this.image});
  @override
  _check_outState createState() => _check_outState();
}

class _check_outState extends State<check_out> {
  final _formKey = GlobalKey<FormState>();

  Future withdraw(String title,String prics,String diamond_ammount,String playerid) async {
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
      'user_player_id':playerid
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

  TextEditingController uid=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){Navigator.pop(context);},),

        title:                 InkWell(
          onTap: () {
            // tryOtaUpdate();

          },
          child: Column(
            children: [
              Text("Checkout".toUpperCase(),
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 18)),

            ],
          ),
        ),

        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.video_library),
        //     onPressed: (){
        //       Navigator.pop(context);
        //     }
        //   ),
        // ],
      ),
        body: SingleChildScrollView(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network( AppUrl.pic_url1 +
               widget.image,fit: BoxFit.cover,height: 200,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  Text("Product Name : ",
                      style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)), Text("100 Diamonde",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                ],
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: uid,
                validator: (v)=>v.isEmpty?"Can't be empty":null,
                decoration: InputDecoration(
                  hintText: "Enter Player Game ID",
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                  prefixIcon: Icon(Icons.store)
                ),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
            if(_formKey.currentState.validate()){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Diamond Purchase"),
                      content: Text("Are you sure you want to buy diamonds?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("YES"),
                          onPressed: () {
                            withdraw(widget.title,widget.price,widget.diamon_amount,uid.text);

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
            }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Checkout",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          )
      ],
    ),
    ),
    ));
  }
}
