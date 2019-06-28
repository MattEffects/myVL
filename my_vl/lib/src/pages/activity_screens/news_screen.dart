import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';

List<String> images = [];

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return newsList();
  }

  Widget newsList() {
    final Firestore _firestore = Firestore.instance;
    // fetchImage();
    return Container(
      child: FutureBuilder<StudentUser>(
          future: BlocProvider.of<StateBloc>(context).activeUser,
          builder: (context, AsyncSnapshot<StudentUser> userSnapshot) {
            if (!userSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            StudentUser user = userSnapshot.data;
            return StreamBuilder(
                stream: _firestore
                    .collection('schools')
                    .document('${user.schoolId}')
                    .collection('news')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> newsSnapshot) {
                  if (!newsSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> documents = newsSnapshot.data.documents;
                  int itemCount = documents.length;
                  if (itemCount == 0) {
                    return Center(child: Text('Pas de news disponibles !'),);
                  }
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int index) {
                      // Définit le style de la première new affichée
                      if (index == 0) {
                        return Card(
                          elevation: 0.0,
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  '${documents[index].data['photoUrl']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Icon(Icons.flight),
                                title: Text('${documents[index].data['title']}'),
                                subtitle: Text(
                                    '${documents[index].data['text'].substring(0, 70)}...'),
                                onTap: () {},
                              ),
                              // ButtonTheme.bar(
                              //   child: ButtonBar(
                              //     children: <Widget>[
                              //       FlatButton(
                              //         child: Text('Lire', style: TextStyle(color: Theme.of(context).accentColor,)),
                              //         onPressed: () {},
                              //       ),
                              //       FlatButton(
                              //         child: Text('Partager', style: TextStyle(color: Theme.of(context).accentColor,)),
                              //         onPressed: () {},
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }
                      // Définit le style de la dernière new affichée
                      if (index == itemCount - 1) {
                        return Card(
                          elevation: 0.0,
                          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10.0),
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                '${documents[index].data['photoUrl']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text('${documents[index].data['title']}'),
                            subtitle: Text(
                                '${documents[index].data['text'].substring(0, 70)}...'),
                            onTap: () {},
                          ),
                        );
                      }
                      // Définit le style d'une new quelconque
                      else {
                        return Card(
                          elevation: 0.0,
                          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10.0),
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                '${documents[index].data['photoUrl']}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text('${documents[index].data['title']}'),
                            subtitle: Text(
                                '${documents[index].data['text'].substring(0, 70)}...'),
                            onTap: () {},
                          ),
                        );
                      }
                    },
                  );
                });
          }),
    );
  }
}
