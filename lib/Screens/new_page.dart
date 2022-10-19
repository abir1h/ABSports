import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MainHome/Bottom_nav_menues/Result.dart';
import 'MainHome/Bottom_nav_menues/ongoing.dart';
import 'MainHome/Daily_matches/Daily_matces_clash_squad_free.dart';
import 'MainHome/Daily_matches/ludo.dart';
import 'MainHome/Daily_matches/ongoing_ludu.dart';
import 'MainHome/Daily_matches/result_ludu.dart';
import 'MainHome/mainHome.dart';

class Appointments extends StatefulWidget {
  final String type,image;
  Appointments({this.type,this.image});

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  TabController _controllertab;
  var name, phone, profile_image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.type);
    _controllertab = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MainHome()));
          },
        ),
        title: Text(
            widget.type == 'p'
                ? "CS Free Fire"
                : widget.type == 'f'
                    ? 'Classic Free Fire'
                    : widget.type == 'l'
                        ? 'Ludo Match'
                        : "Matches",
            style: GoogleFonts.lato(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TabBar(
              controller: _controllertab,
              isScrollable: true,
              indicatorColor: Colors.black,
              tabs: [
                // Tab(icon: Icon(Icons.flight,color: Colors.black,)),
                Tab(
                  child: Text(
                    "Upcoming".toUpperCase(),
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Ongoing'.toUpperCase(),
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'Results'.toUpperCase(),
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            Container(
              height: height / 1.2,
              child: TabBarView(
                controller: _controllertab,
                children: [
                  widget.type=='l'? ludo(type: widget.type,image: widget.image,): Daily_matces_clash_squad_free(type: widget.type,image: widget.image,),
                  widget.type=='l'? ongoing_ludu(type: widget.type,image: widget.image,):ongoing_list(type: widget.type,image: widget.image,),
                  widget.type=='l'? Result_ludu(type: widget.type,image: widget.image,):Result(type: widget.type,image: widget.image,)
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
