import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ent_new/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/takePictureScreen.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/products.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  bool _hasTakenImage = false;
  bool _takeImagePrompt = false;
  bool _isUploading = false;
  var _imagePath;
  var _userId;
  var _imageUrl;
  var _newAddedId;
  CameraDescription camera;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final snackBar = SnackBar(
      content: Text(
    'Yay! You\'ve put something up at College OLX',
    textAlign: TextAlign.center,
  ));
  final snackBarUploading = SnackBar(
      content: Text(
    'Hold On, It\'ll take a sec...',
    textAlign: TextAlign.center,
  ));

  Map<String, dynamic> _formData = {
    'objName': '',
    'price': 0.00,
  };

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((cam) {
      camera = cam.first;
    });
    _hasTakenImage = false;
    super.initState();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    if (!_hasTakenImage) {
      setState(() {
        _takeImagePrompt = true;
      });
      return;
    }
    setState(() {
      _isUploading = true;
      _takeImagePrompt = false;
    });
    Scaffold.of(context).showSnackBar(snackBarUploading);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('productImage/${Path.basename(_imagePath)}}');
    StorageUploadTask uploadTask = storageReference.putFile(File(_imagePath));
    await uploadTask.onComplete;
    print('File Uploaded!!');
    await storageReference.getDownloadURL().then((url) {
      _imageUrl = url;
      print("IMAGE URL: " + _imageUrl);
    });
    await Firestore.instance.collection("products").add({
      'imageUrl': _imageUrl,
      'prodName': _formData['objName'],
      'price': _formData['price'],
      'sellerId': _userId,
    }).then((ref) {
      _newAddedId = ref.documentID;
      print("PRODUCTED UPLOADED ID: " + ref.documentID);
      Provider.of<Products>(context).addItemLocally(Product(
          id: _newAddedId,
          imageUrl: _imageUrl,
          price: double.parse(_formData['price']),
          prodName: _formData['objName'],
          sellerUserId: _userId));
    });
    setState(() {
      _isUploading = false;
      _hasTakenImage = false;
      _formKey.currentState.reset();
      _imagePath = null;
    });
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print('*********ADD ITEM WIDGET BUILT***********');
    _userId = Provider.of<Auth>(context).userId;
    return Container(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 250,
                  child: GestureDetector(
                      onTap: () async {
                        _imagePath = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    TakePictureScreen(camera: camera)));
                        if (_imagePath != null) {
                          print("IMAGE PATH: " + _imagePath);
                          setState(() {
                            _hasTakenImage = true;
                          });
                        }
                      },
                      child: Container(
                        child: Center(
                          child: _hasTakenImage
                              ? Image.file(
                                  File(_imagePath),
                                  fit: BoxFit.contain,
                                  height: 245,
                                  width: 320,
                                )
                              : Text(
                                  'CLICK HERE TO CAPTURE IMAGE\n               (LANDSCAPE)',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          border: Border.all(
                            // color: Colors.black,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
                _hasTakenImage
                    ? Text('Click on the picture to capture a different one')
                    : Text(''),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Object Name',
                              labelStyle: TextStyle(fontSize: 15)),
                          onSaved: (value) {
                            _formData['objName'] = value;
                          },
                          validator: (value) {
                            if (value.length == 0)
                              return 'Cannot be left empty';
                          },
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: TextStyle(fontSize: 15)),
                            onSaved: (value) {
                              _formData['price'] = value;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value.length == 0)
                                return 'Cannot be left empty';
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        if (_takeImagePrompt)
                          Text(
                            'Please take an Image',
                            style: TextStyle(color: Colors.red),
                          ),
                        if (_isUploading)
                          CircularProgressIndicator()
                        else
                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: _submit,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor:
                                Theme.of(context).primaryTextTheme.button.color,
                          ),
                        RaisedButton(
                          child: Text('Reset'),
                          onPressed: () {
                            _formKey.currentState.reset();
                            setState(() {
                              _hasTakenImage = false;
                              _takeImagePrompt = false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Theme.of(context).accentColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button.color,
                        ),
                      ],
                    )),
              ],
            )));
  }
}
