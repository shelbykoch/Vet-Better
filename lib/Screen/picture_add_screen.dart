import 'dart:io';
import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/picture.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureAddScreen extends StatefulWidget {
  static const routeName = '/PictureAddScreen';
  @override
  State<StatefulWidget> createState() {
    return _PictureAddState();
  }
}

class _PictureAddState extends State<PictureAddScreen> {
  _Controller con;
  User user;
  Picture picture;
  List<Picture> pictures;
  int index;
  File image;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg[Constant.ARG_USER];
    picture ??= arg[Constant.ARG_PICTURE];
    //pictures ??= arg[Constant.ARG_PICTURE_LIST];
    index ??= arg['index'];

    return Scaffold(
      appBar: AppBar(
        title:
            picture.docId == null ? Text('Add Picture') : Text("Edit Picture"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'Add your favorite pictures, inspiring content, or whatever makes you happy!'),
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: image != null
                          ? Image.file(image, fit: BoxFit.fill)
                          : picture.docId != null
                              ? Image.network(picture.photoURL)
                              : Icon(Icons.photo_library, size: 300.0),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                          color: Colors.blue[200],
                          child: PopupMenuButton<String>(
                            onSelected: con.getPicture,
                            itemBuilder: (context) => <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: 'camera',
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.photo_camera),
                                    Text('Camera'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'gallery',
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.photo_album),
                                    Text('Gallery'),
                                  ],
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
                con.uploadProgressMessage == null
                    ? SizedBox(
                        height: 1.0,
                      )
                    : Text(con.uploadProgressMessage,
                        style: TextStyle(fontSize: 20.0)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  initialValue: picture.docId != null ? picture.title : "",
                  autocorrect: true,
                  validator: con.validatorTitle,
                  onSaved: con.onSavedTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _PictureAddState _state;
  _Controller(this._state);
  String title;
  String uploadProgressMessage;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();
    if (_state.image == null && _state.picture.docId == null) {
      MyDialog.info(
        context: _state.context,
        title: 'Picture Required',
        content: 'Please add a picture.',
      );
      return;
    }

    try {
      MyDialog.circularProgressStart(_state.context);
      // 1. Upload pic to firebase storage
      if (_state.picture.docId == null) {
        Map<String, String> picture = await FirebaseController.uploadStorage(
            image: _state.image,
            uid: _state.user.uid,
            listener: (double progressPercentage) {
              _state.render(() {
                uploadProgressMessage =
                    'Uploading: ${progressPercentage.toStringAsFixed(1)}';
              });
            });

        // 3. save plantData do to Firestore
        var p = Picture(
          docId: _state.picture.docId,
          title: title,
          photoPath: picture['path'],
          photoURL: picture['url'],
          email: _state.user.email,
        );

        p.docId = await FirebaseController.addPicture(p);
        _state.pictures.insert(0, p);
      } else {
        _state.picture.title = title;
        FirebaseController.updatePicture(_state.picture);
      }

      MyDialog.circularProgressEnd(_state.context);
      Navigator.pop(_state.context);
    } catch (e) {
      print(e);
    }
  }

  void getPicture(String src) async {
    try {
      PickedFile _imageFile;
      if (src == 'camera') {
        _imageFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }

      _state.render(() {
        _state.image = File(_imageFile.path);
      });
    } catch (e) {}
  }

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    this.title = value;
  }
}
