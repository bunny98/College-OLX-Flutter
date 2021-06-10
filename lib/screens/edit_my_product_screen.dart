import 'dart:io';
import 'package:ent_new/constants.dart';
import 'package:ent_new/view_models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import './takePictureScreen.dart';
import 'package:camera/camera.dart';

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
  String _imagePath;
  Product _currProduct;
  ProductViewModel _productViewModel;
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

  Map<String, dynamic> _formData;

  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((cam) {
      if (cam.isNotEmpty) camera = cam.first;
    });
    _currProduct = widget.prod;
    _productViewModel = ProductViewModel.getInstance();
    _formData = {
      'name': _currProduct.name,
      'price': _currProduct.price,
    };
    super.initState();
  }

  // void _onDelete() async {
  //   setState(() {
  //     _isDeleting = true;
  //   });

  //   setState(() {
  //     _isDeleting = false;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar2);
  //   Navigator.of(context).pop();
  // }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setState(() {
      _isUploading = true;
    });
    List<String> _newContentURLs = _currProduct.contentURLs;

    if (_hasTakenImage) {
      // Upload Picture and update _newContentURLs

    }

    //Update Product
    Product newProd = await _productViewModel.updateProduct(
        name: _formData['name'],
        price: _formData['price'],
        productId: _currProduct.id,
        contentURLs: _newContentURLs);

    setState(() {
      _isUploading = false;
      _hasTakenImage = false;
      _currProduct = newProd;
      _imagePath = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print('*********EDIT MYSCREEN BUILT***********');
    return Scaffold(
        backgroundColor: MY_PRODUCTS_BG_COLOR,
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
                                  _currProduct.contentURLs[0],
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
                            ..text = _currProduct.name,
                          decoration: InputDecoration(
                              labelText: 'Product Name',
                              labelStyle: TextStyle(fontSize: 15)),
                          onSaved: (value) {
                            _formData['name'] = value;
                          },
                          validator: (value) {
                            if (value.trim().length == 0)
                              return 'Cannot be left empty';
                          },
                        ),
                        TextFormField(
                            controller: TextEditingController()
                              ..text = _currProduct.price.toString(),
                            decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: TextStyle(fontSize: 15)),
                            onSaved: (value) {
                              _formData['price'] = int.parse(value);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value.trim().length == 0)
                                return 'Cannot be left empty';
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isUploading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                            child: Text('Submit'),
                            onPressed: _submit,
                          ),
                        // if (_isDeleting)
                        //   CircularProgressIndicator()
                        // else
                        //   ElevatedButton(
                        //     child: Text('Delete'),
                        //     onPressed: _onDelete,
                        //   ),
                      ],
                    )),
              ],
            )));
  }
}
