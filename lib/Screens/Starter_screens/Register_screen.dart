import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'Login_screen.dart';
import 'Otp_Screen.dart';

class register_screen extends StatefulWidget {
  @override
  _register_screenState createState() => _register_screenState();
}

class _register_screenState extends State<register_screen> {
  bool _showPassword = false;
  TextEditingController first_name = TextEditingController();
  TextEditingController last = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController promo = TextEditingController();
  TextEditingController Password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
  bool issave=false;

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

  Future registerApi_(String fname,String lname,String email,String phone,String password_,String promo,String Username )async {
    Map<String, String> requestHeaders = {

      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.reg),

    );
    request.fields.addAll({
      'first_name': fname,
      'last_name': lname,
      'email': email,
      'username': Username,
      'phone': phone,
      'password': password_,
      'promo_code':promo
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 201) {

          var data = jsonDecode(response.body);
          print(data);
          print('response.body ' + data.toString());
          Fluttertoast.showToast(

              msg: "Registered  Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));

        }else{
          print("Fail! ");
          var data = jsonDecode(response.body);

          Fluttertoast.showToast(

              msg: data['message'],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Welcome here",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 24)),
                ),Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(icon: Icon(Icons.clear),onPressed: (){Navigator.pop(context);},)
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Let's create your free account using your details",
                  style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
            ),

            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                controller: first_name,
                                style:
                                TextStyle(color: Colors.black),
                                validator: (value) => value.isEmpty
                                    ? "Field Can't be empty"
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.person,color:Colors.black),

                                    hintText: "First Name",
                                    hintStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                controller: last,
                                style:
                                TextStyle(color: Colors.black),
                                validator: (value) => value.isEmpty
                                    ? "Field Can't be empty"
                                    : null,
                                decoration:InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.person,color:Colors.black),

                                    hintText: "Last Name",
                                    hintStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                controller: username,
                                style:
                                TextStyle(color: Colors.black),
                                validator: (value) => value.isEmpty
                                    ? "Field Can't be empty"
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.person,color:Colors.black),

                                    hintText: "Username",
                                    hintStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                controller: phone,
                                style:
                                TextStyle(color: Colors.black),
                                validator: (value) => value.isEmpty
                                    ? "Field Can't be empty"
                                    : null,
                                decoration:InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.phone,color:Colors.black),

                                    hintText: "  Phone",
                                    hintStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                controller: email,
                                style:
                                TextStyle(color: Colors.black),
                                validator: (value) => value.isEmpty
                                    ? "Field Can't be empty"
                                    : null,
                                decoration:InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.mail,color:Colors.black),

                                    hintText: "  Email",
                                    hintStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                controller: Password,    obscureText: !_showPassword,
                                style:
                                TextStyle(color: Colors.black),
                                validator: (value) => value.isEmpty
                                    ? "Field Can't be empty"
                                    : value.length < 6
                                    ? "Password must be 6 digits"
                                    : null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.vpn_key,color: Colors.black,),
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
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container( height:50,
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: TextFormField(
                                obscureText: true,
                                controller: promo,
                                style:
                                TextStyle(color: Colors.black),
                                // validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.group,color: Colors.black,),

                                    hintText: "Refer Code",
                                    hintStyle: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          registerApi_(
                              first_name.text,
                              last.text,
                              email.text,
                              phone.text,
                              Password.text,
                              promo.text,
                              username.text);
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
                            child: Text("Register",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height / 50,
                    ),Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Or",
                          style: GoogleFonts.lato(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: height / 22,
                        width: width ,
                        decoration: BoxDecoration(
                          color:  Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text("Already have an account ?",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 14)),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
