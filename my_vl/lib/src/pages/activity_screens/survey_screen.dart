import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/school_model.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final Firestore firestore = Firestore.instance;
  final list = ['oui', 'yes', 'wow'];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('schools').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        School school = School.fromJson(snapshot.data.documents[0].data);
        if(snapshot.data.documentChanges.length != null ) {
          school = School.fromJson(snapshot.data.documentChanges[0].document.data);
        }
        return Center(
          child: Text(school.toString()),
        );
      },
    );
  }
}
