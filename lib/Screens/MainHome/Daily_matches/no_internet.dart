import 'package:flutter/material.dart';
class no_internet extends StatefulWidget {
  @override
  _no_internetState createState() => _no_internetState();
}

class _no_internetState extends State<no_internet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),

                        // Row(
                        //   children: [
                        //     Image.asset('Images/app_icon.png',height: 150,width: 150,),
                        //     Shimmer.fromColors(
                        //       baseColor: Colors.grey,
                        //       highlightColor: Colors.white,
                        //       child: Text("Sport  Club".toUpperCase(),style: GoogleFonts.lato(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 20
                        //       )),
                        //     ),
                        //   ],
                        // ),
        Center(
            child: Column(
              children: [Image.asset('Images/inter.gif')],
            ))

                      ],
                    ))),
            // Text("This app is under Maintenance")
          ],
        ),
      ),
    );
  }
}
