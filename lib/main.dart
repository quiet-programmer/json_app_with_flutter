import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import './models/post.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.pink),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Post>> _showPost() async {
    
    var data = await http.get("https://jsonplaceholder.typicode.com/posts");
    var dataDecoded = json.decode(data.body);

    List<Post> posts = List();

    dataDecoded.forEach((post) {
      String title = post['title'];
      if (title.length > 30) {
        title = post['title'].substring(1, 30) + "...";
      }
      String body = post['body'].replaceAll(RegExp(r'\n'), " ");
      posts.add(Post(title, body));
    });

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Json App"),
      ),
      body: FutureBuilder(
        future: _showPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 10.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            snapshot.data[index].title,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'serif',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            snapshot.data[index].text,
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Divider(),
                        RaisedButton(
                          elevation: 5.0,
                          color: Colors.pinkAccent,
                          onPressed: () {},
                          child: Text(
                            "Read More...",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          } else {
            return Align(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
