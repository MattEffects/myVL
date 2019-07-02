import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_vl/src/models/story_model.dart';
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
                    .document('${user.school.id}')
                    .collection('news')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> newsSnapshot) {
                  if (!newsSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<StoryData> stories = newsSnapshot.data.documents.map((doc) {
                    return StoryData.fromFirestore(doc);
                  }).toList();
                  int itemCount = stories.length;
                  if (itemCount == 0) {
                    return Center(
                      child: Text('Pas de news disponibles !'),
                    );
                  }
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int index) {
                      // Définit le style de la première new affichée
                      if (index == 0) {
                        return Hero(
                          tag: 'New$index',
                          child: Card(
                            elevation: 0.0,
                            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CachedNetworkImage(
                                  key: UniqueKey(),
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${stories[index].thumbnailUrl}',
                                  imageBuilder: (context, image) {
                                    return AspectRatio(
                                      aspectRatio: 16/9,
                                      child: Image(image: image, fit: BoxFit.cover,),
                                    );
                                  },
                                  placeholder: (context, url) => Container(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.all(10.0),
                                  leading: Icon(Icons.flight),
                                  title:
                                      Text('${stories[index].title}'),
                                  subtitle: Text(
                                      '${stories[index].text.substring(0, 70)}...'),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (context,_,__) {
                                          return Container(
                                            child: GestureDetector(
                                              onVerticalDragStart: Navigator.of(context).pop,
                                              child: Hero(
                                                tag: 'New$index',
                                                child: Theme(
                                                  data: Theme.of(context).brightness != Brightness.dark
                                                    ? Theme.of(context).copyWith(
                                                        primaryColor: Colors.blue,
                                                        accentColor: Colors.blue,
                                                        textSelectionHandleColor: Colors.blue,
                                                        cursorColor: Colors.blue,
                                                      )
                                                    : Theme.of(context).copyWith(
                                                      accentColor: Theme.of(context).primaryColor,
                                                    ),
                                                  child: Story(
                                                    storyData: stories[index],
                                                    index: index,
                                                  ),
                                                ),
                                                transitionOnUserGestures: true,
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // Définit le style de la dernière new affichée
                      if (index == itemCount - 1) {
                        return Hero(
                          tag: 'New$index',
                          child: Card(
                            elevation: 0.0,
                            margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10.0),
                              leading: CachedNetworkImage(
                                key: UniqueKey(),
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${stories[index].thumbnailUrl}',
                                imageBuilder: (context, image) {
                                  return AspectRatio(
                                    aspectRatio: 1,
                                    child: Image(image: image, fit: BoxFit.cover,),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              title: Text('${stories[index].title}'),
                              subtitle: Text(
                                  '${stories[index].text.substring(0, 70)}...'),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context,_,__) {
                                      return Container(
                                        child: GestureDetector(
                                          onVerticalDragStart: Navigator.of(context).pop,
                                          child: Hero(
                                            tag: 'New$index',
                                            child: Theme(
                                              data: Theme.of(context).brightness != Brightness.dark
                                                ? Theme.of(context).copyWith(
                                                    primaryColor: Colors.blue,
                                                    accentColor: Colors.blue,
                                                    textSelectionHandleColor: Colors.blue,
                                                    cursorColor: Colors.blue,
                                                  )
                                                : Theme.of(context).copyWith(
                                                  accentColor: Theme.of(context).primaryColor,
                                                ),
                                              child: Story(
                                                storyData: stories[index],
                                                index: index,
                                              ),
                                            ),
                                            transitionOnUserGestures: true,
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                      // Définit le style d'une new quelconque
                      else {
                        return Hero(
                          tag: 'New$index',
                          child: Card(
                            elevation: 0.0,
                            margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10.0),
                              leading: CachedNetworkImage(
                                key: UniqueKey(),
                                fit: BoxFit.cover,
                                imageUrl:
                                    '${stories[index].thumbnailUrl}',
                                imageBuilder: (context, image) {
                                  return AspectRatio(
                                    aspectRatio: 1,
                                    child: Image(image: image, fit: BoxFit.cover,),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              title: Text('${stories[index].title}'),
                              subtitle: Text(
                                  '${stories[index].text.substring(0, 70)}...'),
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (context,_,__) {
                                      return Container(
                                        child: GestureDetector(
                                          onVerticalDragStart: Navigator.of(context).pop,
                                          child: Hero(
                                            tag: 'New$index',
                                            child: Theme(
                                              data: Theme.of(context).brightness != Brightness.dark
                                                ? Theme.of(context).copyWith(
                                                    primaryColor: Colors.blue,
                                                    accentColor: Colors.blue,
                                                    textSelectionHandleColor: Colors.blue,
                                                    cursorColor: Colors.blue,
                                                  )
                                                : Theme.of(context).copyWith(
                                                  accentColor: Theme.of(context).primaryColor,
                                                ),
                                              child: Story(
                                                storyData: stories[index],
                                                index: index,
                                              ),
                                            ),
                                            transitionOnUserGestures: true,
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                );
                              },
                            ),
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
