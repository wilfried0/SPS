import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/connexion.dart';


class Replay extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  String img = "images/community.jpg";
  int index = 1;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/connexion": (BuildContext context) =>new Connexion()
      },
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/communiti.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: CarouselSlider(
            enlargeCenterPage: true,
            autoPlay: false,
            enableInfiniteScroll: true,
            onPageChanged: (value){
              index = value;
              print(index);
            },
            height: MediaQuery.of(context).size.height,
            items: [1,2,3].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return getMoyen(index, context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Widget getMoyen(int index, BuildContext context){
    String img;
    switch(index){
      case 0:img="images/communiti.jpg";break;
      case 1:img="images/markertplac.jpg";break;
      case 2:img="images/service.jpg";break;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      //margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(0.0),
            ),
            image: DecorationImage(
              image: AssetImage('$img'),
              fit: BoxFit.cover,
            )
        ),),
    );
  }

  Widget makePage({image}){
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover
          )
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(.0),//0.3
                  Colors.black.withOpacity(.0),//0.3
                ]
            )
        ),
      ),
    );
  }
}