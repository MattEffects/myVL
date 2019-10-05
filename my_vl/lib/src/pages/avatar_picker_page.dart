import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_vl/src/blocs/auth_provider.dart';
import 'package:my_vl/src/blocs/bloc_provider.dart';
import 'package:my_vl/src/blocs/state_bloc.dart';
import 'package:my_vl/src/models/user_model.dart';
import 'package:my_vl/src/services/authentication.dart';

class AvatarPickerPage extends StatefulWidget {
  @override
  _AvatarPickerPageState createState() => _AvatarPickerPageState();
}

class _AvatarPickerPageState extends State<AvatarPickerPage> {
  bool _isLoading = false;
  File _imageFile;
  Image _image;
  Firestore _firestore = Firestore.instance;
  ImagePicker imagePicker;
  // Donne une valeur de padding en fonction des dimensions de l'écran
  double _spacing;

  @override
  Widget build(BuildContext context) {
    // Initialisation de spacing en fonction de la taille de l'écran
    setState(() {
      _spacing = MediaQuery.of(context).size.width / 30;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choisir une photo de profil',
          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: Theme.of(context).brightness == Brightness.dark
          ? IconTheme.of(context).copyWith(color: Colors.white)
          : IconTheme.of(context).copyWith(color: Theme.of(context).primaryColor),
      ),
      // Lien du rendu de l'écran d'identification avec les données de Firestore
      // A chaque modification des données de la collection 'school',
      // le widget sera rendu de nouveau
      body: Stack(
        children: <Widget>[
          // Corps de l'écran
          _showBody(),
          // Permet la superposition d'un indicateur de chargement
          _showProgress(),
        ],
      ),
    );
  }

  // Renvoie le corps de l'écran
  // (Appelée par build(), qui rend le widget)
  Widget _showBody() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: Container()),
            // Affiche le logo
            _showProfilePicture(),
            SizedBox(height: _spacing * 4),
            _photoButtons(),
            _imageFile != null ? _deleteButton() : SizedBox(),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.bottomRight,
              child: _nextButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPhotoUrl() async {
    final File image = _imageFile;
    if (image == null) {
      Navigator.pop(context, null);
    }
    else {
      setState(() => _isLoading = true);
      final AuthBase auth = AuthProvider.of(context).auth;
      final FirebaseUser user = await auth.currentUser();
      final StorageReference _storageRef = FirebaseStorage.instance.ref().child('/profile_photos/${user.uid}.png');
      final StorageUploadTask uploadTask = _storageRef.putFile(image);
      final StorageTaskSnapshot snapshot = (await uploadTask.onComplete);
      print('HEY');
      final String photoUrl = (await snapshot.ref.getDownloadURL());
      print('HEY2');
      print(photoUrl);
      await auth.changeUserPhotoUrl(photoUrl);
      print('HEY3');
      print(photoUrl);
      Navigator.pop(context, photoUrl);
    }
  }

  void getImageFile(ImageSource source) async {
    // Sélection d'une image
    File image = await ImagePicker.pickImage(source: source);
    // Recadrage de l'image sélectionnée
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      circleShape: true,
      maxWidth: 512,
      maxHeight: 512,
      toolbarTitle: 'Recadrer',
      toolbarWidgetColor: Theme.of(context).primaryColor,
    );
    File compressedImage = await FlutterImageCompress.compressAndGetFile(
      croppedImage.path,
      croppedImage.path,
      quality: 95,
      format: CompressFormat.png,
      minHeight: 512,
      minWidth: 512,
    );
    setState(() {
      _imageFile = compressedImage;
      print(_imageFile.lengthSync());
    });
  }

  Widget _photoButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: _cameraButton(),
        ),
        SizedBox(width: _spacing),
        Expanded(
          child: _galleryButton(),
        ),
      ],
    );
  }

  Widget _cameraButton() {
    return MaterialButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.camera, color: Colors.white),
          SizedBox(width: _spacing/2),
          Text(
            'Photo',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.subhead.fontSize,
            ),
          ),
        ],
      ),
      height: 42.0,
      color: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
      highlightColor: Theme.of(context).accentColor,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // Quand appuyé, exécute la fonction _submit()
      onPressed: () => getImageFile(ImageSource.camera),
    );
  }

  Widget _galleryButton() {
    return MaterialButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.photo_library, color: Colors.white),
          SizedBox(width: _spacing/2),
          Text(
            'Gallerie',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.subhead.fontSize,
            ),
          ),
        ],
      ),
      height: 42.0,
      color: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
      highlightColor: Theme.of(context).accentColor,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // Quand appuyé, exécute la fonction _submit()
      onPressed: () => getImageFile(ImageSource.gallery),
    );
  }

   Widget _deleteButton() {
    return MaterialButton(
      child: Text(
        'Supprimer la photo',
        style: TextStyle(
          color: Theme.of(context).disabledColor,
        ),
      ),
      splashColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
      highlightColor: Colors.transparent,
      height: 42.0,
      minWidth: MediaQuery.of(context).size.width,
      // highlightColor: Theme.of(context).accentColor,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      // Quand appuyé, éxécute la fonction _cancel()
      onPressed: () => setState(() => _imageFile = null),
    );
  }

  Widget _nextButton() {
    return MaterialButton(
      child: Text(
        _imageFile != null
         ? 'Continuer'
         : 'Passer',
        style: TextStyle(
          color: _imageFile != null
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor,
        ),
      ),
      splashColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
      highlightColor: Colors.transparent,
      height: 42.0,
      // highlightColor: Theme.of(context).accentColor,
      elevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: () => _submitPhotoUrl(),
    );
  }

  Widget _showProfilePicture() {
    StateBloc bloc = BlocProvider.of<StateBloc>(context);
    return ClipOval(
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        width: MediaQuery.of(context).size.width / 2,
        child: _imageFile == null
            ? StreamBuilder<StudentUser>(
              stream: bloc.activeUserStream,
              builder: (BuildContext context, AsyncSnapshot<StudentUser> userSnapshot) {
                if(userSnapshot.hasData && (userSnapshot.data?.photoUrl != null)) {
                  return Image.network(userSnapshot.data.photoUrl);
                }
                return StreamBuilder(
                  stream: _firestore
                      .collection('resources')
                      .document('images')
                      .snapshots(),
                  builder: (context, firestoreSnapshot) {
                    if (!firestoreSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Image.network(firestoreSnapshot.data.data['defaultPhotoUrl']);
                  },
                );
              },
            )
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _showProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
