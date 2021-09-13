import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/search.dart';

class Album {
  String title;
  String desc;
  String image;

  Album({this.title, this.desc, this.image});

  factory Album.fromJson(
    Map<String, dynamic> json,
  ) {
    return Album(
        title: json['title'], desc: json['description'], image: json['image']);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _bar = [
    'Top250Movies',
    'MostPopularMovies',
    'MostPopularTvs',
    'InTheaters',
    'ComingSoon',
  ];
  w(v1, pw) {
    return ind(pw * (v1 / 360));
  }

  h(v1, ph) {
    return ind(ph * (v1 / 760));
  }

  ind(n) {
    int i1 = n.toString().indexOf('.');
    return double.parse(n.toString().substring(0, i1));
  }

  String selectedbar = "Top250Movies";
  String s4;

  Future<List<Album>> _getmovies() async {
    String s1 = 'https://imdb-api.com/en/API/';
    var s3 = '/k_86ncnqb8';
    var qu = Uri.parse(s1 + selectedbar + s3);

    var responce = await http.get(qu);
    if (responce.statusCode == 200) {
      Iterable j1 = json.decode(responce.body)['items'];
      print(json.decode(responce.body)['items']);
      return j1.map((album) {
        return Album.fromJson(album);
      }).toList();
    } else {
      print("Error from server function _getmovies");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getmovies();
  }

  var sh = false;

  Widget _horizon(filter) {
    var pw = MediaQuery.of(context).size.width;
    var ph = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedbar = filter;
          sh = true;
          _getmovies().whenComplete(() {
            setState(() {
              sh = false;
            });
          });
        });
      },
      child: Card(
          margin: EdgeInsets.only(
              left: w(8, pw), right: w(8, pw), bottom: h(5, ph), top: h(5, ph)),
          elevation: 8,
          color: selectedbar == filter ? Colors.orange : Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
                left: w(13.0, pw), right: w(13, pw), top: h(9, ph)),
            child: Text(filter,
                style: TextStyle(
                    color: selectedbar == filter ? Colors.white : Colors.black,
                    fontSize: w(18, pw))),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pw = MediaQuery.of(context).size.width;
    var ph = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: h(145, ph),
        backgroundColor: Colors.white,
        leadingWidth: 0,
        titleSpacing: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: h(70, ph),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                  ),
                  Icon(
                    Icons.movie_rounded,
                    color: Colors.white,
                    size: w(30, pw),
                  ),
                  SizedBox(
                    width: w(20, pw),
                  ),
                  Text(
                    "Movies",
                    style: TextStyle(
                        fontSize: w(28, pw),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: w(60, pw),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: w(5.0, pw)),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>Serach()),);
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: w(34, pw),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h(10, ph),
            ),
            Container(
              height: h(55, ph),
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _horizon(_bar[index]);
                },
                itemCount: _bar.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: h(20, ph),
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          sh
              ? Container()
              : FutureBuilder(
                  future: _getmovies(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _vertical(snapshot.data[index].title,
                                snapshot.data[index].image);
                          },
                          itemCount: snapshot.data.length > 15
                              ? 15
                              : snapshot.data.length);
                    } else {
                      return Center(
                        child: Container(
                            margin: EdgeInsets.only(top: h(100, ph)),
                            height: h(100, ph),
                            width: w(100, pw),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(w(20.0, pw)),
                              child: SpinKitCircle(
                                  color: Colors.orange, size: w(60, pw)),
                            )),
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget _vertical(title, image) {
    var pw = MediaQuery.of(context).size.width;
    var ph = MediaQuery.of(context).size.height;
    return Container(
      height: h(460, ph),
      margin: EdgeInsets.all(w(20, pw)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill)),
      child: Padding(
        padding: EdgeInsets.only(
            left: w(15.0, pw), top: h(20, ph), right: w(10, pw)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: h(30, ph),
                    width: w(50, pw),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 4)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(w(5, pw)),
                      child: Row(
                        children: [
                          Text("4.3",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: w(14, pw))),
                          Icon(Icons.star,
                              size: w(15, pw), color: Colors.orange),
                        ],
                      ),
                    )),
                Icon(Icons.favorite, color: Colors.red, size: w(30, pw)),
              ],
            ),
            SizedBox(
              height: h(275, ph),
            ),
            AutoSizeText(title,
                maxLines: 2,
                minFontSize: w(21, pw),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: w(24, pw),
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          offset: Offset(3, 3),
                          blurRadius: 50),
                      Shadow(
                          color: Colors.black,
                          offset: Offset(-3, -3),
                          blurRadius: 50),
                    ])),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: h(10, ph), top: h(3, ph)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Action, Drama, Sci-fi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w(19, pw),
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(3, 3),
                                        blurRadius: 50),
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(-3, -3),
                                        blurRadius: 50),
                                  ])),
                        ]),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: h(10, ph), left: w(8, pw), top: h(3, ph)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(2, 2))
                            ]),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: h(5.0, ph), horizontal: w(12, pw)),
                          child: Text("Book",
                              style: TextStyle(
                                  color: Colors.white, fontSize: w(22, pw))),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}