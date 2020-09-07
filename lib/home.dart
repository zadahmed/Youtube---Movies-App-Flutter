import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> movielist = List<String>();
  loaddata() async {
    var url =
        "https://api.themoviedb.org/3/movie/550?api_key=c874b73c2e165d984925d886da07cbe0";
    final response = await http.get(url);

    var jsonbody = json.decode(response.body);
    var page = jsonbody['page'];
    var results = jsonbody['results'];

    for (int i = 0; i <= results.length; i++) {
      movielist.add(results[i]['original_title']);
    }

    setState(() {
      movielist = movielist;
    });
  }

  @override
  void initState() {
    super.initState();

    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favourite Movies'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: movielist.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(movielist[index]),
            );
          }),
    );
  }
}
