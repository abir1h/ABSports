
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;

class password_popup extends StatefulWidget {

  @override
  _password_popupState createState() => _password_popupState();
}

class _password_popupState extends State<password_popup> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Future logoutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return await http.post(
      Uri.parse("http://bestaid.com.bd/api/employee/logout"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'authorization': "Bearer $token",
      },
    );
  }
  final _formKey = GlobalKey<FormState>();
  bool issave=false;
  TextEditingController email_ = TextEditingController();
  TextEditingController password_ = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      backgroundColor:Colors.transparent,
      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );

  }

  contentBox(context){
    String _chosenValue;
    return
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/1.2,bottom: 30),
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height/15,
                  decoration: BoxDecoration(
                    color:  Color(0xFF262837),
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child:TextField(

                              decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                                            hintText: 'Write Comment',
                                            hintStyle: TextStyle(color: Colors.white),
                                            border: InputBorder.none,
                                            suffixIcon: IconButton(icon: Icon(Icons.send,color: Colors.white,),onPressed: (){
                                              Navigator.pop(context);
                                            },)
                                        ),
                                      )


              ),
            ],
          ),
        ),
      );
  }
}
