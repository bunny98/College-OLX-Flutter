import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ent_new/models/user.dart';
import 'package:ent_new/view_models/product_model.dart';
import 'package:ent_new/view_models/user_model.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/takePictureScreen.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  ProductViewModel _productViewModel;
  bool _hasTakenImage = false;
  bool _takeImagePrompt = false;
  bool _isUploading = false;
  User _currUser;
  var _imagePath;
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
    'name': '',
    'price': 0.00,
  };

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((cam) {
      if (cam.isNotEmpty)
        camera = cam.first;
      else
        camera = null;
    });
    _hasTakenImage = false;
    _productViewModel = ProductViewModel.getInstance();
    _currUser = UserViewModel.getInstance().getCurrUser();
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
    ScaffoldMessenger.of(context).showSnackBar(snackBarUploading);
    //Upload Image
    await Future.delayed(Duration(seconds: 1));
    String _uploadedURL = "https://googleflutter.com/sample_image.jpg";

    //Create Product
    bool retVal = await _productViewModel.createProduct(
        name: _formData["name"],
        price: _formData["price"],
        contentURLs: [_uploadedURL],
        collegeId: _currUser.collegeId,
        sellerId: _currUser.id);

    if (retVal) {
      setState(() {
        _isUploading = false;
        _hasTakenImage = false;
        _formKey.currentState.reset();
        _imagePath = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                      color: Colors.black),
                                ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
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
                            _formData['name'] = value;
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
                              FilteringTextInputFormatter.digitsOnly
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
                          ElevatedButton(
                            child: Text('Submit'),
                            onPressed: _submit,
                          ),
                        ElevatedButton(
                          child: Text('Reset'),
                          onPressed: () {
                            _formKey.currentState.reset();
                            setState(() {
                              _hasTakenImage = false;
                              _takeImagePrompt = false;
                            });
                          },
                        ),
                      ],
                    )),
              ],
            )));
  }
}
