import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Roome_ng extends StatefulWidget {
  @override
  _Roome_ngState createState() => _Roome_ngState();
}

class _Roome_ngState extends State<Roome_ng> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );
  }

  contentBox(context) {
    String _chosenValue;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              height: 50,
              width: width,
              color: Color(0xFFFFD700),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Room Details',
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('আপনি এখনো মাচটি জয়েন করেননি!!',
                          style: GoogleFonts.lato(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                              child: Text(
                            "Close",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
