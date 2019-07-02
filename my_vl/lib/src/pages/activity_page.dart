import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/services/authentication.dart';
import 'package:my_vl/src/widgets/animated_bottom_bar.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'package:my_vl/src/pages/activity_screens/news_screen.dart';
import 'package:my_vl/src/pages/activity_screens/poll_screen.dart';
import 'package:my_vl/src/pages/activity_screens/feedback_screen.dart';
import 'package:my_vl/src/pages/activity_screens/results_screen.dart';

class ActivityPage extends StatefulWidget {

  // Enonciation des différents écrans de notre navigation
  final List<Widget> screens = [
    NewsScreen(),
    PollScreen(),
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
    bool _isDark = Theme.of(context).brightness == Brightness.dark;

    // Enonciation des différents items de notre barre de navigation
    final List<BarItem> barItems = [
      BarItem(
        text: 'Nouvelles',
        iconData: OMIcons.insertDriveFile,
        selectedIconData: Icons.insert_drive_file,
        color: _isDark ? Colors.lightBlue[200] : Colors.blue,
      ),
      BarItem(
        text: 'Sondages',
        iconData: OMIcons.insertChart,
        selectedIconData: Icons.insert_chart,
        color: _isDark ? Colors.pinkAccent[100] : Colors.pinkAccent,
      ),
      BarItem(
        text: 'Propositions',
        iconData: OMIcons.chatBubbleOutline,
        selectedIconData: Icons.chat_bubble,
        color: _isDark ? Colors.orange[400] : Colors.yellow[900],
      ),
      BarItem(
        text: 'Résultats',
        iconData: OMIcons.school,
        selectedIconData: Icons.school,
        color: _isDark ? Colors.teal[200] : Colors.teal,
      ),
    ];
    
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text(
          '${barItems[selectedBarIndex].text}',
          style: TextStyle(color: barItems[selectedBarIndex].color),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: SizedBox(),
      ),

      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: barItems[selectedBarIndex].color,
          accentColor: barItems[selectedBarIndex].color,
          // textSelectionColor: barItems[selectedBarIndex].color.withOpacity(0.5),
          textSelectionHandleColor: barItems[selectedBarIndex].color,
          cursorColor: barItems[selectedBarIndex].color,),
        child: widget.screens[selectedBarIndex],
      ),

      bottomNavigationBar: AnimatedBottomBar(
          barItems: barItems,
          animationDuration: const Duration(milliseconds: 150),
          onBarTap: (index) {
            setState(() {
              selectedBarIndex = index;
            });
          }),
    );
  }

  Color _newsColor(ThemeData theme) {
    switch (theme.brightness) {
      case Brightness.light:
        return Colors.indigo[800];
      case Brightness.dark:
        return Colors.lightBlue[50];
      default:
        return Colors.indigo[800];
    }
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
  Widget _buildDrawer() {
    // Suivi d'un layout responsive à l'aide du widget MediaQuery
    // qui nous donne des informations sur l'écran de l'utilisateur
    final StateBloc bloc = BlocProvider.of<StateBloc>(context);
    final _tilesPadding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width / 7,
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
                                    String imageUrl = (snapshot.data.photoUrl == null)
                                    ? snapshot2.data.data['defaultPhotoUrl']
                                    : snapshot.data.photoUrl;
                                    return InkWell(
                                      onTap: () {
                                        print(imageUrl);
                                        Navigator.of(context).push(
                                        PageRouteBuilder(
                                          opaque: true,
                                          pageBuilder: (context,_,__) {
                                            return Container(
                                              child: GestureDetector(
                                                onVerticalDragStart: Navigator.of(context).pop,
                                                onTap: Navigator.of(context).pop,
                                                child: Hero(
                                                  tag: 'Avatar',
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl,
                                                    fit: BoxFit.contain,
                                                    placeholder: (context, url) => CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  ),
                                                  transitionOnUserGestures: true,
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                      );},
                                      child: ClipOval(
                                        child: Hero(
                                          tag: 'Avatar',
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                          transitionOnUserGestures: true,
                                        )
                                      ),
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
                            '${snapshot.data.school.name} - ${snapshot.data.classroomName}',
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
