import 'package:flutter/material.dart';

List<String> images = [];

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  @override
  Widget build(BuildContext context) {
    final int itemCount = 15;
    // fetchImage();
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          // Définit le style de la première new affichée
          if (index == 0) {
            return Card(
              elevation: 3.0,
              margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
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
                          child: Text('Lire', style: TextStyle(color: Theme.of(context).accentColor,)),
                          onPressed: () {},
                        ),
                        FlatButton(
                          child: Text('Partager', style: TextStyle(color: Theme.of(context).accentColor,)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // Définit le style de la dernière new affichée
          if (index == itemCount-1) {
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
          } 
          // Définit le style d'une new quelconque
          else {
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
