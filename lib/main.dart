import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(MaterialApp(home: VirtuoozaHome()));
}

class VirtuoozaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VirtuoozaHomeState();
}

class VirtuoozaHomeState extends State<VirtuoozaHome> {
  // Base URL for our wordpress API
  final String apiUrl = "http://labancaria2.obliviondev.com.ar/wp-json/wp/v2/";
  // Empty list for our posts
  late List posts;

  //Function to fetch list of posts
  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});
    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("La Bancaria MDP"), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    new FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: posts[index]["featured_media"] == 0
                          ? ''
                          : posts[index]["_embedded"]["wp:featuredmedia"][0]
                              ["source_url"],
                    ),
                    new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new ListTile(
                        title: new Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: new Text(posts[index]["title"]["rendered"])),
                        subtitle: new Text(posts[index]["excerpt"]["rendered"]
                            .replaceAll(new RegExp(r'<[^>]*>'), '')),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
