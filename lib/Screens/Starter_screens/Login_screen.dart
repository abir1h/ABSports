import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:sports_club/Screens/MainHome/mainHome.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Register_screen.dart';
import 'forget_pass.dart';

class login_screen extends StatefulWidget {
  @override
  _login_screenState createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  var token;
  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
  }

  final _formKey = GlobalKey<FormState>();
  bool islogin = false;
  bool issave = false;
  TextEditingController email_ = TextEditingController();
  TextEditingController password_ = TextEditingController();
  Future login(String email, String password) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    request.fields.addAll({
      'phone': email != null ? email : '02222221',
      'password': password,
      'player_id': player_id != null ? player_id : '',
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data['status_code']);
          print('response.body ' + data.toString());
          if (data['status_code'] == 200) {
            setState(() {
              islogin = false;
            });

            print(data['token']['plainTextToken']);
            print(player_id);
            print(data['data']['username']);
            saveprefs(
                data['token']['plainTextToken'],
                data['data']['phone'],
                data['data']['username'],
                data['data']['email'],
                data['data']['last_name'],
                data['data']['first_name']);
            print("Success! ");
            Fluttertoast.showToast(
                msg: "Login Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.black,
                fontSize: 16.0);

            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          } else {
            setState(() {
              islogin = false;
            });
            print("Fail! ");
            var data = jsonDecode(response.body);
print(data);
            Fluttertoast.showToast(
                msg: "Unauthorized",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        } else {
          print("Fail! ");
          setState(() {
            islogin = false;
          });

          print(jsonDecode(response.body));

          return response.body;
        }
      });
    });
  }

  var player_id;
  func() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);
    setState(() {
      player_id = playerId;
    });
  }

  saveprefs(
    String token,
    String phone,
    String usernamem,
    String email,
    String last_name,
    String first_name,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('phone', phone);
    prefs.setString('user_name', usernamem);
    prefs.setString('email', email);
    prefs.setString('last_name', last_name);
    prefs.setString('first_name', first_name);
    setState(() {
      issave = true;
    });
    if (issave == true) {
      getdata();
    }
  }
  bool _showPassword = false;
  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var user = prefs.getString('user_name');
    var fname = prefs.getString('first_name');
    var lname = prefs.getString('last_name');
    var email = prefs.getString('email');
    var phone = prefs.getString('phone');
    print('Token ' + token);
    print('fname= ' + fname);
    print('lname ' + lname);
    print('email ' + email);
    print('phoneno ' + phone);
    print('user ' + user);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func();
  }

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
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Welcome back",
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Let's login with your account details to continure",
                  style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
            ),
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Container(
                        height:50,
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextFormField(
                          controller: email_,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black),
                          validator: (value) =>
                              value.isEmpty ? "Field Can't be empty" : null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.phone),

                              hintText: "  Phone",
                              hintStyle: GoogleFonts.lato(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18)),
                        ),
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      Column(
                        children: [
                          Container(
                            height:50,
                            decoration: BoxDecoration(
                                color: Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: TextFormField(
                              controller: password_,                      obscureText: !_showPassword,

                              style: TextStyle(color: Colors.black),
                              validator: (value) =>
                              value.isEmpty ? "Field Can't be empty" : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.vpn_key),
                                  suffixIcon:GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                    child: Icon(_showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  hintText: "  Password",
                                  hintStyle: GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: InkWell(
                          //     onTap: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (_) => forget_password()));
                          //     },
                          //     child: Text("Forgot Password",
                          //         style: GoogleFonts.lato(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w700,
                          //             fontSize: 14)),
                          //   ),
                          // )
                        ],
                      )
                    ],
                  ),
                )),

            islogin == false
                ? Center(
                  child: InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            islogin = true;
                          });
                          login(email_.text, password_.text);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: height / 20,
                          width: width ,
                          decoration: BoxDecoration(
                            color: Color(0xFF00BCD5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text("Login",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 20)),
                          ),
                        ),
                      ),
                    ),
                )
                : SpinKitThreeInOut(
                    color: Colors.black,
                    size: 20,
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Or",
                        style: GoogleFonts.lato(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => register_screen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height / 22,
                        width: width ,
                        decoration: BoxDecoration(
                          color:  Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text("Create Account",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => forget_password()));
                },
                child: Text("Forgot Password?",
                    style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 20)),
              ),
            )
          ],
        )),
      ),
    );
  }
}
