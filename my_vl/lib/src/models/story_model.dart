import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryData {
  String id;
  String title;
  String text;
  String thumbnailUrl;
  String by;
  var time;

  StoryData.fromFirestore(DocumentSnapshot doc)
      : id = doc.data['id'],
        title = doc.data['title'],
        text = doc.data['text'],
        thumbnailUrl = doc.data['thumbnailUrl'],
        by = doc.data['by'].documentID,
        time = doc.data['time'];
}

class Story extends StatefulWidget {
  final StoryData storyData;
  final int index;
  Story({this.storyData, this.index});
  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    double _spacing = MediaQuery.of(context).size.width / 20;
    StoryData story = widget.storyData;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: Offset(3.0, 3.0),
            blurRadius: 20.0,
          ),
        ],
      ),
      child: Scaffold(
        appBar: Theme.of(context).brightness == Brightness.dark
          ? AppBar(
              title: Text('${story.title}'),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : AppBar(
              title: Text('${story.title}', style: TextStyle(color: Theme.of(context).primaryColor)),
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0,
              leading: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,),
            ),
        body: Center(
          child: Container(
            padding: EdgeInsets.only(bottom: _spacing),
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        key: UniqueKey(),
                        fit: BoxFit.cover,
                        imageUrl: story.thumbnailUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    
                    Container(
                      margin: EdgeInsets.all(_spacing),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${story.title}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.title,
                          ),
                          SizedBox(height: _spacing,),
                          Text(
                            '${story.text}',
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Hero(
//   tag: 'thumbnail${widget.index}',
//   child: Container(),
// ),
