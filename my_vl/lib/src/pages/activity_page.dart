import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'package:my_vl/src/widgets/animated_bottom_bar.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'package:my_vl/src/pages/activity_screens/news_screen.dart';
import 'package:my_vl/src/pages/activity_screens/survey_screen.dart';
import 'package:my_vl/src/pages/activity_screens/feedback_screen.dart';
import 'package:my_vl/src/pages/activity_screens/results_screen.dart';

class ActivityPage extends StatefulWidget {

  // Enonciation des différents items de notre barre de navigation
  final List<BarItem> barItems = [
    BarItem(
      text: 'Nouvelles',
      iconData: OMIcons.insertDriveFile,
      selectedIconData: Icons.insert_drive_file,
      color: Colors.indigo,
    ),
    BarItem(
      text: 'Sondages',
      iconData: OMIcons.insertChart,
      selectedIconData: Icons.insert_chart,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: 'Propositions',
      iconData: OMIcons.chatBubbleOutline,
      selectedIconData: Icons.chat_bubble,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: 'Résultats',
      iconData: OMIcons.school,
      selectedIconData: Icons.school,
      color: Colors.teal,
    ),
  ];

  // Enonciation des différents écrans de notre navigation
  final List<Widget> screens = [
    NewsScreen(),
    SurveyScreen(),
    FeedbackScreen(),
    ResultsScreen(),
  ];

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int selectedBarIndex = 0;
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text(
          '${widget.barItems[selectedBarIndex].text}',
          style: TextStyle(color: widget.barItems[selectedBarIndex].color),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: SizedBox(),
      ),

      body: Theme(
        data: Theme.of(context).copyWith(primaryColor: widget.barItems[selectedBarIndex].color, accentColor: widget.barItems[selectedBarIndex].color,),
        child: widget.screens[selectedBarIndex],
      ),

      bottomNavigationBar: AnimatedBottomBar(
          barItems: widget.barItems,
          animationDuration: const Duration(milliseconds: 150),
          onBarTap: (index) {
            setState(() {
              selectedBarIndex = index;
            });
          }),
    );
  }

  Color _textColor(ThemeData theme) {
    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black.withOpacity(0.5);
      case Brightness.dark:
        return Theme.of(context).iconTheme.color; // null - use current icon theme color
    }
    return Colors.pink;
  }
  _signOut() async {
    try {
      final AuthBase auth = AuthProvider.of(context).auth;
      Navigator.of(context).pop();
      BlocProvider.of<StateBloc>(context).toggleDarkMode(false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  // Construit le Drawer de navigation
  // (Appelée par la propriété "drawer:" de la Scaffold() de la page)
  _buildDrawer() {
    // Suivi d'un layout responsive à l'aide du widget MediaQuery
    // qui nous donne des informations sur l'écran de l'utilisateur
    final StateBloc bloc = BlocProvider.of<StateBloc>(context);
    final _tilesPadding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width / 9,
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 3 / 4,
      child: Drawer(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).size.height / 15,
            0,
            MediaQuery.of(context).size.height / 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Partie profil de l'utilisateur, qui écoute le stream de StudentUser
              StreamBuilder<StudentUser>(
                stream: bloc.activeUserStream,
                builder: (context, snapshot) {
                  return Expanded(
                    flex: 3,
                    child: (!snapshot.hasData) 
                    ? Center(child: CircularProgressIndicator(),)
                    : Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: _firestore.collection('resources').document('images').snapshots(),
                                builder: (context, snapshot2) {
                                  if (snapshot2.hasData) {
                                    return CircleAvatar(
                                      backgroundImage: (snapshot.data.photoUrl == null)
                                        ? NetworkImage(snapshot2.data.data['defaultPhotoUrl'])
                                        : NetworkImage(snapshot.data.photoUrl),
                                    );
                                  }
                                  return CircularProgressIndicator();
                                }
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            '${snapshot.data.fullName}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '${snapshot.data.schoolName} - ${snapshot.data.classroomName}',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ListTile(
                        contentPadding: _tilesPadding,
                        leading: Icon(OMIcons.mail),
                        title: AutoSizeText(
                          'Messagerie',
                          presetFontSizes: [18.0, 16.0],
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _textColor(Theme.of(context)),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        contentPadding: _tilesPadding,
                        leading: Icon(Icons.restaurant),
                        title: AutoSizeText(
                          'Restauration',
                          presetFontSizes: [18.0, 16.0],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: _textColor(Theme.of(context)),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: _tilesPadding,
                        leading: Icon(Icons.tune),
                        title: AutoSizeText(
                          'Paramètres',
                          presetFontSizes: [18.0, 16.0],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: _textColor(Theme.of(context)),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        contentPadding: _tilesPadding,
                        leading: Icon(Icons.cancel),
                        title: AutoSizeText(
                          'Déconnexion',
                          presetFontSizes: [18.0, 16.0],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: _textColor(Theme.of(context)),
                          ),
                        ),
                        onTap: _signOut,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: StreamBuilder<dynamic>(
                      stream: BlocProvider.of<StateBloc>(context).darkMode,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            onTap: () {
                              BlocProvider.of<StateBloc>(context)
                                  .toggleDarkMode(!snapshot.data);
                            },
                            child: AnimatedContainer(
                              width: 100.0,
                              height: 40.0,
                              duration: const Duration(milliseconds: 200),
                              child: Center(
                                child: Text(
                                  snapshot.data ? 'Mode Jour' : 'Mode Nuit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: snapshot.data
                                        ? Colors.grey[800]
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: snapshot.data
                                    ? Colors.lightBlue[50]
                                    : Colors.indigo[800],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                          );
                        }
                        return InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          onTap: () {
                            BlocProvider.of<StateBloc>(context)
                                .toggleDarkMode(true);
                          },
                          child: AnimatedContainer(
                            width: 100.0,
                            height: 40.0,
                            duration: const Duration(milliseconds: 200),
                            child: Center(
                              child: Text(
                                'Mode Nuit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.indigo[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                            )
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
