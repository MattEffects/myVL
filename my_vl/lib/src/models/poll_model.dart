import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'dart:math';

class Choice {
  String label;
  int score;
  DocumentSnapshot document;
  Choice(this.label, this.score);
  Choice.fromFirestore(doc)
    : label = doc.data['label'],
      score = doc.data['score'],
      document = doc;
  
  @override
  String toString() {
    return '$label, $score';
  }
}

class PollData {
  String title;
  String text;
  List<Choice> choices;
  var time;
  DocumentSnapshot document;

  PollData.fromFirestore(DocumentSnapshot doc, List<DocumentSnapshot> choices)
    : title = doc.data['title'],
      text = doc.data['text'],
      choices = _getChoices(choices),
      time = doc.data['time'],
      document = doc;

  static List<Choice> _getChoices(List<DocumentSnapshot> choicesList) {
    List<Choice> parsedChoices = [];
    choicesList.forEach((choice) {
      Choice choiceToAdd = Choice.fromFirestore(choice);
      parsedChoices.add(choiceToAdd);
    });
    return parsedChoices;
  }

  @override
  String toString() {
    return '$title, $text, $choices';
  }
}

class Poll extends StatefulWidget {
  final PollData pollData;
  final int index;
  Poll({this.pollData, this.index});
  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  var _formKey = GlobalKey<FormState>();
  int choiceValue = 0;
  bool sent = false;
  @override
  Widget build(BuildContext context) {
    var poll = widget.pollData;
    return Container(
      // padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${poll.title}',
            style: Theme.of(context).textTheme.subhead,
          ),
          // Text('${poll.text}'),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choicesChildren()+[
                FlatButton.icon(
                  label: Text('Submit'),
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () => setState(() => sent = !sent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    widget.pollData.choices[choiceValue].document.reference.updateData(
      {
        'score': FieldValue.increment(1),
      },
    );
  }

  List<Widget> choicesChildren() {
    List<Widget> choiceWidgets = [];

    PollData poll = widget.pollData;
    if(!sent) {
      poll.choices.forEach((choice) {
        int index = poll.choices.indexOf(choice);
        Widget choiceWidgetToAdd = Row(
          children: <Widget>[
            Radio<int>(
              activeColor: Theme.of(context).primaryColor,
              value: index,
              groupValue: choiceValue,
              onChanged: (value) {
                setState(() {
                  choiceValue = value;
                });
              },
            ),
            GestureDetector(
              child: Text('${choice.label}'),
              onTap: () {
                setState(() {
                  choiceValue = index;
                });
              },
            )
          ],
        );
        choiceWidgets.add(choiceWidgetToAdd); 
      });
    }
    else {
      int totalScore = 0;
      List<int> scores = [];
      poll.choices.forEach((choice) {
        totalScore += choice.score;
        scores.add(choice.score);
      });
      int maxScore = scores.reduce(max);
      poll.choices.sort((choice1, choice2) => choice2.score.compareTo(choice1.score));
      poll.choices.forEach((choice) {
        Widget resultWidgetToAdd = LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: (choice.score == maxScore)
                    ? constraint.maxWidth
                    : constraint.maxWidth*(choice.score/maxScore),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.all(10),
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${(choice.score/totalScore*100).round()}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: constraint.maxWidth/50,),
                      Text(
                        '${choice.label}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
        choiceWidgets.add(resultWidgetToAdd);
      });
    }

    return choiceWidgets;
  }
}