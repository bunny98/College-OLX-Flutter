import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import './takePictureScreen.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/products.dart';

class EditMyProductScreen extends StatefulWidget {
  final Product prod;
  @override
  EditMyProductScreen({Key key, this.prod}) : super(key: key);
  @override
  EditMyProductScreenState createState() => EditMyProductScreenState();
}

class EditMyProductScreenState extends State<EditMyProductScreen> {
  bool _isDeleting = false;
  bool _hasTakenImage = false;
  bool _isUploading = false;
  var _imagePath;
  var _imageUrl;
  CameraDescription camera;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final snackBar = SnackBar(
      content: Text(
    'Yay! You\'ve Updated your rental',
    textAlign: TextAlign.center,
  ));
  final snackBar2 = SnackBar(
      content: Text(
    'You\'ve Deleted it  :(',
    textAlign: TextAlign.center,
  ));

  Map<String, dynamic> _formData = {
    'objName': '',
    'price': 0.00,
  };

  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((cam) {
      camera = cam.first;
    });
    super.initState();
  }

  void _onDelete() async {
    setState(() {
      _isDeleting = true;
    });
    await Firestore.instance
        .collection("products")
        .document(widget.prod.id)
        .delete();
    
    var docs = await Firestore.instance
        .collection("requests")
        .document(widget.prod.id)
        .collection(widget.prod.id)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; i++) {
      var doc = docs.documents[i];
      await Firestore.instance
          .collection("requests")
          .document(widget.prod.id)
          .collection(widget.prod.id)
          .document(doc.documentID)
          .updateData({
        'response': 'Deleted',
      });
    }
    Provider.of<Products>(context).onAcceptRemoveSameReq(widget.prod.id);
    Provider.of<Products>(context).deleteItemLocally(widget.prod);
    setState(() {
      _isDeleting = false;
    });
    Scaffold.of(context).showSnackBar(snackBar2);
    Navigator.of(context).pop();
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setState(() {
      _isUploading = true;
    });
    if (_hasTakenImage) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('productImage/${Path.basename(_imagePath)}}');
      StorageUploadTask uploadTask = storageReference.putFile(File(_imagePath));
      await uploadTask.onComplete;
      print('NEW File Uploaded!!');
      await storageReference.getDownloadURL().then((url) {
        _imageUrl = url;
        print("NEW IMAGE URL: " + _imageUrl);
      });
    }
    await Firestore.instance
        .collection("products")
        .document(widget.prod.id)
        .updateData({
      'imageUrl': _imageUrl,
      'prodName': _formData['objName'],
      'price': _formData['price'],
    }).then((_) {
      print('EVERYTHING UPDATED!');
    });
    Provider.of<Products>(context).updateLocally(Product(
        id: widget.prod.id,
        imageUrl: _imageUrl,
        price: double.parse(_formData['price']),
        prodName: _formData['objName'],
        sellerUserId: widget.prod.sellerUserId));
    setState(() {
      _isUploading = false;
      _hasTakenImage = false;
      // _imagePath = null;
    });
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _imageUrl = widget.prod.imageUrl;
    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
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
                          _hasTakenImage = true;
                        }
                      },
                      child: Container(
                        child: Center(
                          child: _hasTakenImage
                              ? Image.file(
                                  File(_imagePath),
                                  fit: BoxFit.cover,
                                  height: 245,
                                  width: 320,
                                )
                              : Image.network(
                                  widget.prod.imageUrl,
                                  fit: BoxFit.cover,
                                  height: 254,
                                  width: 320,
                                ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ),
                _hasTakenImage
                    ? Center(
                        child: Text(
                            'Click on the picture to capture a different one'))
                    : Center(
                        child: Text('Click on the picture to capture again')),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: TextEditingController()
                            ..text = widget.prod.prodName,
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
                            controller: TextEditingController()
                              ..text = widget.prod.price.toString(),
                            decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: TextStyle(fontSize: 15)),
                            onSaved: (value) {
                              _formData['price'] = value;
                            },
                            validator: (value) {
                              if (value.length == 0)
                                return 'Cannot be left empty';
                            }),
                        SizedBox(
                          height: 20,
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
                        if (_isDeleting)
                          CircularProgressIndicator()
                        else
                          RaisedButton(
                            child: Text('Delete'),
                            onPressed: _onDelete,
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
