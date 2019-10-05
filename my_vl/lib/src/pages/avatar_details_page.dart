import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/pages/avatar_picker_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarDetailsPage extends StatelessWidget {
  final String avatarUrl;
  final String userId;
  AvatarDetailsPage({@required this.avatarUrl, @required this.userId});
  @override
  Widget build(BuildContext context) {
    StateBloc bloc = BlocProvider.of<StateBloc>(context);
    Firestore firestore = Firestore.instance;
    return GestureDetector(
      onVerticalDragStart: Navigator.of(context).pop,
      onTap: Navigator.of(context).pop,
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'Avatar',
              child: StreamBuilder<StudentUser>(
                stream: bloc.activeUserStream,
                builder: (context, userSnapshot) {
                  return CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    imageUrl: userSnapshot.hasData 
                      ? userSnapshot.data.photoUrl
                      : avatarUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                }
              ),
              transitionOnUserGestures: true,
            ),
            SizedBox(height: 20.0,),
            OutlineButton(
              color: Colors.white,
              borderSide: BorderSide(color: Colors.white),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Text('Changer la photo'),
              onPressed: () async {
                String photoUrl = await Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: true,
                    transitionDuration: Duration(milliseconds: 200),
                    pageBuilder: (context, animation, animation2) {
                      return AvatarPickerPage();
                    },
                    transitionsBuilder: (context, animation, animation2, child) {
                      return SlideTransition(
                        position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(animation),
                        child: SlideTransition(
                          position: Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0)).animate(animation2),
                          child: child,
                        ),
                      );
                    },
                  ),
                );
                firestore.collection('users').document('$userId').updateData({
                  'photoUrl': photoUrl == null ? avatarUrl : photoUrl,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}