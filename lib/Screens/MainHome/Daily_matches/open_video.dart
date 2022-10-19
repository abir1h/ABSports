
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_club/Screens/Appurl/Appurl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart'as http;
import 'package:pip_view/pip_view.dart';

import '../mainHome.dart';

class open_video extends StatefulWidget {
  final String link,id,views,title;
  open_video({this.link,this.id,this.views,this.title});
  @override
  _open_videoState createState() => _open_videoState();
}

class _open_videoState extends State<open_video>with TickerProviderStateMixin {
   YoutubePlayerController _controller;
   TextEditingController _idController;
   TextEditingController _seekToController;

   PlayerState _playerState;
   YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];
   final _formKey = new GlobalKey<FormState>();

   Future slide,comment_list;
   Future emergency() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String token = prefs.getString('token');

     Map<String, String> requestHeaders = {
       'Accept': 'application/json',
       'authorization': "Bearer $token"
     };
var id=widget.id;
     var response =
     await http.get(Uri.parse(AppUrl.Show_video2+id), headers: requestHeaders);
     if (response.statusCode == 200) {
       print('Get post collected' + response.body);
       var userData1 = jsonDecode(response.body)['data'];
setState(() {
  v=userData1['views'].toString();
});
       print('matahnso');
       print(v);

       print(userData1);
       return userData1;
     } else {
       print("post have no Data${response.body}");
     }
   }
   Timer _timer;

   FocusNode focusNode;
   final ScrollController new_scrollController = ScrollController();
   bool _needsScroll = false;
   _startTimer() {
     _timer = Timer.periodic(Duration(seconds: 2), (_) {
       setState(() {
         _needsScroll = true;
       });
     });
   }
   _scrollToEnd() async {
     if (_needsScroll) {
       _needsScroll = false;
       new_scrollController.animateTo(new_scrollController.position.maxScrollExtent,
           duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
     }
   }

   CommentDone(String comment)async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String token = prefs.getString('token');

     Map<String, String> requestHeaders = {
       'Accept': 'application/json',
       'authorization': "Bearer $token"
     };
     var request = await http.MultipartRequest(
       'POST',
       Uri.parse(AppUrl.cmpost+widget.id),
     );
     request.fields.addAll({
'comment':comment,
     });

     request.headers.addAll(requestHeaders);

     request.send().then((result) async {
       http.Response.fromStream(result).then((response) {
         if (response.statusCode == 200) {
           print('Success');
           print(response.body);
           setState(() {
             comment_list=comment_op();

           });
           // Timer(
           //     Duration(milliseconds: 300),
           //         () => _scrollControllertoTop
           //         .jumpTo(_scrollControllertoTop.position.maxScrollExtent));
           comment_to.clear();

           FocusScope.of(context).unfocus();
           Navigator.pop(context);
           // _scrollControllertoTop
           //     .jumpTo(_scrollControllertoTop.position.maxScrollExtent);
         } else {
           print('Fail');
           print(response.body);
           setState(() {
             comment_list=comment_op();

           });
           comment_to.clear();
           FocusScope.of(context).unfocus();
           Navigator.pop(context);

         }
       });
     });
   }  ScrollController _scrollControllertoTop;
   void _scrollToTop() {
     print(_scrollControllertoTop.offset);
     print(_scrollControllertoTop.offset);
     _scrollControllertoTop.animateTo(2,
         duration: Duration(milliseconds: 800), curve: Curves.linear);
   }

   TextEditingController comment_to=TextEditingController();
   Future<List<dynamic>> comment_op() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String token = prefs.getString('token');

     Map<String, String> requestHeaders = {
       'Accept': 'application/json',
       'authorization': "Bearer $token"
     };
    var id=widget.id;
     var response =
     await http.get(Uri.parse(AppUrl.cm+id), headers: requestHeaders);
     if (response.statusCode == 200) {
       print('Get post collected' + response.body);
       var userData1 = jsonDecode(response.body)['data'];

       print('comment');

       print(userData1);
       return userData1;
     } else {
       print("post have no Data${response.body}");
     }
   }
   var v;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:  YoutubePlayer
          .convertUrlToId(
          widget.link),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    slide=emergency();
    comment_list=comment_op();
    _startTimer();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    _scrollControllertoTop.dispose();
    _timer.cancel();
    super.dispose();
  }
   RefreshController _refreshController =
   RefreshController(initialRefresh: false);

   void _onRefresh() async{
     // monitor network fetch
     await Future.delayed(Duration(milliseconds: 1000));
     // if failed,use refreshFailed()
     setState(() {
       slide=emergency();

     });
     _refreshController.refreshCompleted();
   }

   void _onLoading() async{
     // monitor network fetch
     await Future.delayed(Duration(milliseconds: 1000));
     // if failed,use loadFailed(),if no data return,use LoadNodata()
     setState(() {
       slide=emergency();

     });
     if(mounted)
       setState(() {
         slide=emergency();

       });
     _refreshController.loadComplete();
   }
   reassemble() {
     super.reassemble();
     _timer?.cancel();
     _startTimer();
   }



   @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
    onEnterFullScreen: (){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,aspectRatio: 2,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings,
          //     color: Colors.white,
          //     size: 25.0,
          //   ),
          //   onPressed: () {
          //     log('Settings Tapped!');
          //   },
          // ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {

          _showSnackBar('Please Subscribe us to Support!!!');
        },
      ),
      builder: (context, player) =>PIPView(
        floatingWidth: MediaQuery.of(context).size.width/3,
        floatingHeight: MediaQuery.of(context).size.height/5,
        initialCorner: PIPViewCorner.bottomRight,

        builder: (context, isFloating) {

          return Scaffold(

            backgroundColor:  Color(0xFF1F1D2C),
            appBar: AppBar(
              backgroundColor: Color(0xFF1F1D2C),

              title:                 Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.blue,
                child: InkWell(
                  onTap: () {
                    // tryOtaUpdate();

                  },
                  child: Column(
                    children: [
                      Text("AB sports".toUpperCase(),
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18)),

                    ],
                  ),
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
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:2.0,right: 2.0),
                  child: GestureDetector(

                      onVerticalDragStart: ( details){
                        print(details);
                        PIPView.of(context).presentBelow(MainHome());

                      },
                      child: player),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0,right: 2,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [

                      // _space,
                      // TextField(
                      //   enabled: _isPlayerReady,
                      //   controller: _idController,
                      //   decoration: InputDecoration(
                      //     border: InputBorder.none,
                      //     hintText: 'Enter youtube \<video id\> or \<link\>',
                      //     fillColor: Colors.blueAccent.withAlpha(20),
                      //     filled: true,
                      //     hintStyle: const TextStyle(
                      //       fontWeight: FontWeight.w300,
                      //       color: Colors.blueAccent,
                      //     ),
                      //     suffixIcon: IconButton(
                      //       icon: const Icon(Icons.clear),
                      //       onPressed: () => _idController.clear(),
                      //     ),
                      //   ),
                      // ),
                      // Row(
                      //   children: [
                      //     _loadCueButton('LOAD'),
                      //     const SizedBox(width: 10.0),
                      //     _loadCueButton('CUE'),
                      //   ],
                      // ),
                      // _space,
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF262837),

                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20) )
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // IconButton(
                                //   icon: const Icon(Icons.skip_previous,color: Colors.white,),
                                //   onPressed: _isPlayerReady
                                //       ? () => _controller.load(_ids[
                                //   (_ids.indexOf(_controller.metadata.videoId) -
                                //       1) %
                                //       _ids.length])
                                //       : null,
                                // ),
                                IconButton(
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,                            color: Colors.white,

                                  ),
                                  onPressed: _isPlayerReady
                                      ? () {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                    setState(() {});
                                  }
                                      : null,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(_muted ? Icons.volume_off : Icons.volume_up,                            color: Colors.white,
                                      ),
                                      onPressed: _isPlayerReady
                                          ? () {
                                        _muted
                                            ? _controller.unMute()
                                            : _controller.mute();
                                        setState(() {
                                          _muted = !_muted;
                                        });
                                      }
                                          : null,
                                    ),
                                    FullScreenButton(
                                      controller: _controller,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),

                                // IconButton(
                                //   icon: const Icon(Icons.skip_next),
                                //   onPressed: _isPlayerReady
                                //       ? () => _controller.load(_ids[
                                //   (_ids.indexOf(_controller.metadata.videoId) +
                                //       1) %
                                //       _ids.length])
                                //       : null,
                                // ),

                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 8.0,right: 8),
                            //   child: Row(
                            //     children: <Widget>[
                            //       const Text(
                            //         "Volume",
                            //         style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white),
                            //       ),
                            //       Expanded(
                            //         child: Slider(
                            //           inactiveColor: Colors.blueGrey,
                            //           activeColor: Colors.white,
                            //           value: _volume,
                            //           min: 0.0,
                            //           max: 100.0,
                            //           divisions: 10,
                            //           label: '${(_volume).round()}',
                            //           onChanged: _isPlayerReady
                            //               ? (value) {
                            //             setState(() {
                            //               _volume = value;
                            //             });
                            //             _controller.setVolume(_volume.round());
                            //           }
                            //               : null,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),


                      _space,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height/20,
                          child: Text(_videoMetaData.title, style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                        ),
                      ),
                      v==null? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.views+" Views ", style: GoogleFonts.lato(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w800,
                                fontSize: 12)),

                          ],
                        ),
                      ): Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,

                          children: [
                            Text(v.toString()+" Views ", style: GoogleFonts.lato(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w800,
                                fontSize: 12)),
                            InkWell(
                              onTap: ()async{
                                var url = 'https://www.youtube.com/channel/UC3cXSyBz0wKZt9R4AnG937A';
                                if (await canLaunch(url))
                                  await launch(url);
                                else
                                  // can't launch url, there is some error
                                  throw "Could not launch $url";
                              },
                              child: Container(
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red,
                                ),
                                child:Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("Subscribe", style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      Divider(color: Colors.white30,),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: GestureDetector(
                      //       onTap: (){
                      //         // showDialog(
                      //         //     context: context,
                      //         //     builder: (context) {
                      //         //       return AlertDialog(
                      //         //         backgroundColor: Color(0xFF262837),
                      //         //
                      //         //         titlePadding: EdgeInsets.zero,
                      //         //         contentPadding: EdgeInsets.zero,
                      //         //         elevation: 0.0,
                      //         //         // title: Center(child: Text("Evaluation our APP")),
                      //         //         content:TextField(
                      //         //           autofocus: true,
                      //         //
                      //         //           decoration: InputDecoration(
                      //         //               prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                      //         //               hintText: 'Write Comment',
                      //         //               hintStyle: TextStyle(color: Colors.white),
                      //         //               border: InputBorder.none,
                      //         //               suffixIcon: IconButton(icon: Icon(Icons.send,color: Colors.white,),)
                      //         //           ),
                      //         //         ),);
                      //         //     });
                      //         // showDialog(
                      //         //     context: context,
                      //         //     builder: (context) {
                      //         //       return password_popup();
                      //         //     });
                      //         // showModalBottomSheet(
                      //         //   backgroundColor: Colors.transparent,
                      //         //   isScrollControlled: true,
                      //         //
                      //         //
                      //         //
                      //         //   context: context,
                      //         //   builder: (context) => Container(
                      //         //       height: MediaQuery.of(context).size.height/15,
                      //         //       decoration: BoxDecoration(
                      //         //         color:  Color(0xFF262837),
                      //         //         borderRadius: BorderRadius.circular(10),
                      //         //
                      //         //       ),
                      //         //       child: TextField(
                      //         //         autofocus: true,
                      //         //
                      //         //         decoration: InputDecoration(
                      //         //             prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                      //         //             hintText: 'Write Comment',
                      //         //             hintStyle: TextStyle(color: Colors.white),
                      //         //             border: InputBorder.none,
                      //         //             suffixIcon: IconButton(icon: Icon(Icons.send,color: Colors.white,),)
                      //         //         ),
                      //         //       )
                      //         //
                      //         //
                      //         //   ),
                      //         // );
                      //       },
                      //       child: Container(
                      //           height: MediaQuery.of(context).size.height/15,
                      //           decoration: BoxDecoration(
                      //             color:  Color(0xFF262837),
                      //             borderRadius: BorderRadius.circular(10),
                      //
                      //           ),
                      //           child:  Container(
                      //               height: MediaQuery.of(context).size.height/15,
                      //               decoration: BoxDecoration(
                      //                 color:  Color(0xFF262837),
                      //                 borderRadius: BorderRadius.circular(10),
                      //
                      //               ),
                      //               child: TextField(
                      //                 focusNode: focusNode,
                      //                 style:
                      //                 TextStyle(color: Colors.white),
                      //                 controller: comment_to,
                      //
                      //
                      //                 decoration: InputDecoration(
                      //                     prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                      //                     hintText: 'Write Comment',
                      //                     hintStyle: TextStyle(color: Colors.white),
                      //                     border: InputBorder.none,
                      //                     suffixIcon: IconButton(icon: Icon(Icons.send,color: Colors.white,),onPressed: (){
                      //                       comment_to.text!=null?CommentDone(comment_to.text):     Fluttertoast.showToast(
                      //                           msg: "Comment can't be empty",
                      //                           toastLength: Toast.LENGTH_LONG,
                      //                           gravity: ToastGravity.BOTTOM,
                      //                           timeInSecForIosWeb: 1,
                      //                           backgroundColor: Colors.black54,
                      //                           textColor: Colors.black,
                      //                           fontSize: 16.0);
                      //                     },)
                      //                 ),
                      //               )
                      //
                      //
                      //           ),
                      //
                      //       ),
                      //     ),
                      //   ),
                      // )          ,    // _space,
Align(
  alignment: Alignment.topLeft,
  child:Text("Comments", style: GoogleFonts.lato(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14)),
),
                      // Divider(color: Colors.white30,),
                      Container(
                          height: MediaQuery.of(context).size.height/3,
                          child: FutureBuilder<List<dynamic>>(
                              future: comment_list,
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
                                          ?  snapshot.data.length>0?    Padding(
                                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                                        child: Column(
                                          children: [
                                        Container(
                                        height: MediaQuery.of(context).size.height/3.2,
                                        child:  SmartRefresher(
                                          enablePullDown: true,
                                          enablePullUp: false,
                                          header: WaterDropHeader(),
                                          footer: CustomFooter(
                                            builder: (BuildContext context,LoadStatus mode){
                                              Widget body ;
                                              if(mode==LoadStatus.idle){
                                                body =  CupertinoActivityIndicator();
                                              }
                                              else if(mode==LoadStatus.loading){
                                                body =  CupertinoActivityIndicator();
                                              }
                                              else if(mode == LoadStatus.failed){
                                                body = Text("Load Failed!Click retry!");
                                              }
                                              else if(mode == LoadStatus.canLoading){
                                                body = Text("release to load more");
                                              }
                                              else{
                                                body = Text("No more Data");
                                              }
                                              return Container(
                                                height: 55.0,
                                                child: Center(child:body),
                                              );
                                            },
                                          ),
                                          controller: _refreshController,
                                          onRefresh: _onRefresh,
                                          onLoading: _onLoading,
                                          child: ListView.builder(
                                              controller: new_scrollController,
                                            // reverse: true,
                                            //   reverse: true,
                                              shrinkWrap: true,
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context,index){
                                                var dateTime = DateTime.parse(snapshot.data[index]['created_at']);

                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:2.0,top: 8),
                                                        child: Row(
                                                          children: [
                                                            CircularProfileAvatar(null,
                                                                borderColor: Colors.black,
                                                                borderWidth: 3,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkIq9DjIgYbGgIenjkjA-tkr3mN1_bBnsEw&usqp=CAU',
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) =>
                                                                      CircularProgressIndicator(),
                                                                  errorWidget: (context, url, error) =>
                                                                      Icon(Icons.person),
                                                                ),
                                                                elevation: 5,
                                                                radius: 20),
                                                            Container(
                                                              width:MediaQuery.of(context).size.width/2,
                                                              decoration: BoxDecoration(
                                                                  color:  Colors.white,
                                                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20),topRight:Radius.circular(20) )
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(snapshot.data[index]['users']['username'], style: GoogleFonts.lato(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w800,
                                                                            fontSize: 11)),Text( DateFormat.yMMMMd('en_US') .format(dateTime), style: GoogleFonts.lato(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w800,
                                                                            fontSize: 8)),
                                                                      ],
                                                                    ), Text(snapshot.data[index]['comment'], style: GoogleFonts.lato(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w800,
                                                                        fontSize: 10)),
                                                                  ],
                                                                ),
                                                              ),
                                                            )

                                                          ],
                                                        ),
                                                      ),




                                                      SizedBox(height: 10,)

                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                          ],
                                        ),
                                      ):Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            height: MediaQuery.of(context).size.height/3,

                                            child: Padding(
                                              padding: const EdgeInsets.only(top:40.0),
                                              child: Text('No Comments',style: TextStyle(color: Colors.white),),
                                            )),
                                      )


                                          : Text('No data');
                                    }
                                }
                                return Center(child: CircularProgressIndicator());
                              })),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (){
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         backgroundColor: Color(0xFF262837),
                              //
                              //         titlePadding: EdgeInsets.zero,
                              //         contentPadding: EdgeInsets.zero,
                              //         elevation: 0.0,
                              //         // title: Center(child: Text("Evaluation our APP")),
                              //         content:TextField(
                              //           autofocus: true,
                              //
                              //           decoration: InputDecoration(
                              //               prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                              //               hintText: 'Write Comment',
                              //               hintStyle: TextStyle(color: Colors.white),
                              //               border: InputBorder.none,
                              //               suffixIcon: IconButton(icon: Icon(Icons.send,color: Colors.white,),)
                              //           ),
                              //         ),);
                              //     });
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return password_popup();
                              //     });
                              // showModalBottomSheet(
                              //   backgroundColor: Colors.transparent,
                              //   isScrollControlled: true,
                              //
                              //
                              //
                              //   context: context,
                              //   builder: (context) => Container(
                              //       height: MediaQuery.of(context).size.height/15,
                              //       decoration: BoxDecoration(
                              //         color:  Color(0xFF262837),
                              //         borderRadius: BorderRadius.circular(10),
                              //
                              //       ),
                              //       child: TextField(
                              //         autofocus: true,
                              //
                              //         decoration: InputDecoration(
                              //             prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                              //             hintText: 'Write Comment',
                              //             hintStyle: TextStyle(color: Colors.white),
                              //             border: InputBorder.none,
                              //             suffixIcon: IconButton(icon: Icon(Icons.send,color: Colors.white,),)
                              //         ),
                              //       )
                              //
                              //
                              //   ),
                              // );
                              showDialog(

                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  double width = MediaQuery.of(context).size.width;
                                  double height = MediaQuery.of(context).size.height;
                                  return AlertDialog(

                                      backgroundColor: Colors.transparent,
                                      contentPadding: EdgeInsets.only(left: 10,right: 10),
                                      insetPadding: EdgeInsets.only(left: 2,right: 2),
                                      elevation: 0.0,

                                      // title: Center(child: Text("Evaluation our APP")),
                                      content: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [

                                          Container(
                                              // height: MediaQuery.of(context).size.height/15,
                                              width:MediaQuery.of(context).size.width ,
                                              decoration: BoxDecoration(
                                                color:  Color(0xFF262837),
                                                borderRadius: BorderRadius.circular(10),

                                              ),
                                              child: Form(
                                                key: _formKey,
                                                child: TextFormField(
                                                  focusNode: focusNode,
                                                  autofocus: true,

                                                  style:
                                                  TextStyle(color: Colors.white),
                                                  controller: comment_to,

                                                  validator: (value) => value.isEmpty
                                                      ? 'Please Write Something'
                                                      : null,
                                                  decoration: InputDecoration(

                                                      prefixIcon: Icon(Icons.chat,color:  Color(0xFF666873),),
                                                      hintText: 'Write Comment',
                                                      hintStyle: TextStyle(color: Colors.white),
                                                      border: InputBorder.none,
                                                      suffixIcon: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          height: 20 ,

                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white
                                                          ),
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: 5),
                                                            child: IconButton(icon: Icon(Icons.send,color: Colors.black,size: 20,),onPressed: (){
print(                                                            comment_to.text+ 'tuq'

);
if(_formKey.currentState.validate()){
  CommentDone(comment_to.text);
}else{
  Fluttertoast.showToast(
      msg: "Comment can't be empty",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 10.0);
}// _scrollToTop();
                                                            },),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              )


                                          ),
                                        ],
                                      ));
                                },
                              );
                            },
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: MediaQuery.of(context).size.height/15,
                                decoration: BoxDecoration(
                                  color:  Color(0xFF262837),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.chat,color: Colors.white,),
                                        Text(" Write Comment",style: TextStyle(color: Colors.white),)
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(

                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: IconButton(icon: Icon(Icons.send,color: Colors.black,size: 20,),onPressed: (){
                                            // comment_to.text!=null?CommentDone(comment_to.text):     Fluttertoast.showToast(
                                            //     msg: "Comment can't be empty",
                                            //     toastLength: Toast.LENGTH_LONG,
                                            //     gravity: ToastGravity.BOTTOM,
                                            //     timeInSecForIosWeb: 1,
                                            //     backgroundColor: Colors.black54,
                                            //     textColor: Colors.black,
                                            //     fontSize: 16.0);
                                            // _scrollToTop();

                                          },),
                                        ),
                                      ),
                                    )
                                  ],
                                )


                              ),
                            ),
                          ),
                        ),
                      )          ,    // _space,


                      // _text('Channel', _videoMetaData.author),
                      // _space,
                      // _text('Video Id', _videoMetaData.videoId),
                      //
                      // _space,
                      // Row(
                      //   children: [
                      //     _text(
                      //       'Playback Quality',
                      //       _controller.value.playbackQuality ?? '',
                      //     ),
                      //     const Spacer(),
                      //     _text(
                      //       'Playback Rate',
                      //       '${_controller.value.playbackRate}x  ',
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
          if (_idController.text.isNotEmpty) {
            var id = YoutubePlayer.convertUrlToId(
              _idController.text,
            ) ??
                '';
            if (action == 'LOAD') _controller.load(id);
            if (action == 'CUE') _controller.cue(id);
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            _showSnackBar('Source can\'t be empty!');
          }
        }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}