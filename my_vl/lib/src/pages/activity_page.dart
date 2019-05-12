import 'package:flutter/material.dart';
import 'package:my_vl/src/services/authentication.dart';
import '../widgets/animated_bottom_bar.dart';
import 'activity_screens/news_screen.dart';
import 'activity_screens/survey_screen.dart';
import 'activity_screens/feedback_screen.dart';
import 'activity_screens/results_screen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class ActivityPage extends StatefulWidget {
  ActivityPage({@required this.auth, @required this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

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
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text('${widget.barItems[selectedBarIndex].text}'),
        centerTitle: true,
        backgroundColor: widget.barItems[selectedBarIndex].color,
        leading: SizedBox(),
      ),

      body: widget.screens[selectedBarIndex],

      // body: AnimatedContainer(
      //   duration: const Duration(milliseconds: 150),
      //   color: widget.barItems[selectedBarIndex].color,
      // ),

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

  _buildDrawer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 3 / 4,
      child: Drawer(
        child: Stack(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.cover,
              //     image: AssetImage('assets/bg_imgs/girl_book.jpg'),
              //   ),
              // ),
              padding: EdgeInsets.symmetric(
                vertical: 35.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/bg_imgs/girl_book.jpg'),
                            radius: 80,
                          ),
                        ),
                        Text(
                          'Noémie Currato',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Jean Jaurès - TS',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 180,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 70.0,
                            ),
                            leading: Icon(OMIcons.mail),
                            title: Text(
                              'Messagerie',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                          // Test Handmade de ListTile
                          // InkWell(
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 0.0,
                          //       vertical: 15.0,
                          //     ),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.max,
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: <Widget>[
                          //         Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: <Widget>[
                          //             Icon(
                          //               Icons.restaurant,
                          //               color: Colors.black.withOpacity(0.5),
                          //             ),
                          //             SizedBox(width: 30.0),
                          //             Text(
                          //               'Restauration',
                          //               style: TextStyle(
                          //                 fontSize: 18.0,
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.black.withOpacity(0.5),
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //     Navigator.pushNamed(context, '/restauration');
                          //   },
                          // ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 70.0,
                            ),
                            leading: Icon(Icons.restaurant),
                            title: Text(
                              'Restauration',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/restauration');
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 70.0,
                            ),
                            leading: Icon(Icons.tune),
                            title: Text(
                              'Paramètres',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/settings'),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 70.0,
                            ),
                            leading: Icon(Icons.cancel),
                            title: Text(
                              'Déconnexion',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            onTap: () {
                              widget.auth.signOut()..then((value) => widget.onSignedOut());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        onTap: () {
                          setState(() {
                            _isDark = !_isDark;
                          });
                        },
                        child: AnimatedContainer(
                          width: 100.0,
                          height: 40.0,
                          duration: const Duration(milliseconds: 200),
                          child: Center(
                            child: Text(
                              _isDark ? 'Mode Jour' : 'Mode Nuit',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color:
                                    _isDark ? Colors.grey[800] : Colors.white,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: _isDark
                                ? Colors.lightBlue[50]
                                : Colors.indigo[800],
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          // child: Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: <Widget>[
                          //     Text(
                          //       'Night Mode',
                          //     ),
                          //     Switch(
                          //       value: _switchValue,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           _switchValue = value;
                          //         });
                          //       },
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
