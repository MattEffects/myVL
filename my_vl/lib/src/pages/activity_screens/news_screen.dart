import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

List<String> images = [];

class ImageModel {
  int id;
  String title;
  String url;
  List<dynamic> photos = [];

  ImageModel.fromJson(Map<String, dynamic> parsedJson) {
    // id = parsedJson['id'];
    // title = parsedJson['title'];
    photos = (parsedJson['photos'] == null) ? [] : parsedJson['photos'];
    url = photos.isEmpty 
      ? 'https://images.pexels.com/photos/934964/pexels-photo-934964.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260'
      : photos[0]['url'];
  }

  ImageModel(this.id, this.title, this.url);

  @override
  String toString() {
    // TODO: implement toString
    return id.toString();
  }
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  void fetchImage() async {
    final response = await http.get(
      'https://api.pexels.com/v1/curated?per_page=1&page=1',
      headers: {
        HttpHeaders.authorizationHeader:
            '563492ad6f91700001000001da19147ec4784cfb88f1ba55914b133d'
      },
    );
    final responseJson = json.decode(response.body);
    setState(() {
      images.add(ImageModel.fromJson(responseJson).url);
    });
  }

  @override
  Widget build(BuildContext context) {
    // fetchImage();
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Card(
              elevation: 3.0,
              margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      'https://images.pexels.com/photos/934964/pexels-photo-934964.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                      // images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: Icon(Icons.timeline),
                    title: Text('Une aventure étourdissante'),
                    subtitle: Text(
                        'Joshua, en Terminale STL, a décidé de rencontrer ses démons en allant au Mexique'),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text('Lire'),
                          onPressed: () {},
                        ),
                        FlatButton(
                          child: Text('Partager'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (index == 9) {
            return Card(
              margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://images.pexels.com/photos/934964/pexels-photo-934964.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text('Une aventure étourdissante'),
                subtitle: Text(
                    'Joshua, en Terminale STL, a décidé de rencontrer ses démons en allant au Mexique'),
              ),
            );
            // 563492ad6f91700001000001da19147ec4784cfb88f1ba55914b133d
          } else {
            return Card(
              margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    'https://images.pexels.com/photos/934964/pexels-photo-934964.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text('Une aventure étourdissante'),
                subtitle: Text(
                    'Joshua, en Terminale STL, a décidé de rencontrer ses démons en allant au Mexique'),
              ),
            );
          }
        },
      ),
    );
  }
}
