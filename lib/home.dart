import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Movies {
  final String title;
  final String image;

  Movies({this.image, this.title});
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movies> movielist = List<Movies>();
  List<Movies> discoverlist = List<Movies>();

  loadtrendingmovies() async {
    var url =
        "https://api.themoviedb.org/3/trending/movies/week?api_key=c874b73c2e165d984925d886da07cbe0";
    final response = await http.get(url);

    var jsonbody = json.decode(response.body);
    var results = jsonbody['results'];

    print(results);
    for (int i = 0; i < results.length; i++) {
      if (results[i]['title'] != null) {
        var posterurl =
            'http://image.tmdb.org/t/p/w500' + results[i]['poster_path'];
        Movies movies =
            new Movies(title: results[i]['title'], image: posterurl);
        movielist.add(movies);
      } else if (results[i]['name'] != null) {
        var posterurl =
            'http://image.tmdb.org/t/p/w500' + results[i]['poster_path'];
        Movies movies = new Movies(title: results[i]['name'], image: posterurl);
        movielist.add(movies);
      }
    }

    setState(() {
      movielist = movielist;
    });
  }

  loaddiscovermovies() async {
    var url =
        "https://api.themoviedb.org/3/discover/movie?api_key=c874b73c2e165d984925d886da07cbe0&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1";
    final response = await http.get(url);

    var jsonbody = json.decode(response.body);
    var results = jsonbody['results'];

    for (int i = 0; i < results.length; i++) {
      if (results[i]['title'] != null) {
        var posterurl =
            'http://image.tmdb.org/t/p/w500' + results[i]['poster_path'];
        Movies movies =
            new Movies(title: results[i]['title'], image: posterurl);
        discoverlist.add(movies);
      } else if (results[i]['name'] != null) {
        var posterurl =
            'http://image.tmdb.org/t/p/w500' + results[i]['poster_path'];
        Movies movies = new Movies(title: results[i]['name'], image: posterurl);
        discoverlist.add(movies);
      }
    }

    setState(() {
      discoverlist = discoverlist;
    });
  }

  @override
  void initState() {
    super.initState();
    loaddiscovermovies();
    loadtrendingmovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Favourite Movies'),
          backgroundColor: Colors.black,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(
                  'Trending Movies',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                padding: EdgeInsets.all(5),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height / 3,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: discoverlist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: 200,
                              color: Colors.white,
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    child: Image.network(
                                      discoverlist[index].image,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          discoverlist[index].title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      )),
                                ],
                              )));
                    }),
              ),
              Padding(
                child: Text(
                  'Discover Movies',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                padding: EdgeInsets.all(5),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: movielist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                movielist[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(movielist[index].title),
                        );
                      }))
            ]));
  }
}
