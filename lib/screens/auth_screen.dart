import 'package:ent_new/models/college.dart';
import 'package:ent_new/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/overview_screen.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print("WIDTH: " + deviceSize.height.toString());
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'CollegeOlx',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 30,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 5 : 4,
                    fit: FlexFit.loose,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  static const String ADD_COLLEGE_ITEM_ID = "ADD";
  static const String NAME_KEY = "name";
  static const String MOB_NUM_KEY = "mobile";

  final GlobalKey<FormState> _formKey = GlobalKey();
  final UserViewModel _userViewModel = UserViewModel.getInstance();

  var _isLoading = false;
  College _chosenCollege;

  Map<String, String> _authData = {NAME_KEY: "", MOB_NUM_KEY: ""};

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    if (_chosenCollege == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select a college"),
      ));
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    bool retVal = await _userViewModel.signUp(
        name: _authData[NAME_KEY],
        collegeId: _chosenCollege.id,
        mobNum: _authData[MOB_NUM_KEY]);

    _userViewModel.setCurrCollege = _chosenCollege;

    setState(() {
      _isLoading = false;
    });
    if (retVal)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => OverViewScreen()),
        (_) => false,
      );
  }

  Widget getDropdownCollegeWidget(List<College> colleges) {
    List<DropdownMenuItem<College>> items = colleges
        .map((e) => DropdownMenuItem<College>(
              child: Text(e.name),
              value: e,
            ))
        .toList();
    items.add(DropdownMenuItem(
      child: Text("Add..."),
      value: College(id: ADD_COLLEGE_ITEM_ID, name: "Add...", numOfStudents: 0),
    ));
    return DropdownButton(
      isExpanded: true,
      value: _chosenCollege,
      items: items,
      hint: Text("Choose Your College"),
      onChanged: (college) async {
        if (college.id == ADD_COLLEGE_ITEM_ID) {
          await showAddCollegeDialog(context: context);
        } else {
          setState(() {
            _chosenCollege = college;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        width: deviceSize.width * 0.85,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Name', labelStyle: TextStyle(fontSize: 15)),
                  validator: (val) {
                    if (val.trim().isEmpty) return "Cannot be empty";
                  },
                  onSaved: (value) {
                    _authData[NAME_KEY] = value.trim();
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(fontSize: 15)),
                  validator: (val) {
                    if (val.trim().length != 10) return "Invalid Number";
                  },
                  onSaved: (value) {
                    _authData[MOB_NUM_KEY] = value.trim();
                  },
                ),
                Consumer<UserViewModel>(
                    builder: (context, model, _) => Container(
                        width: double.infinity,
                        child: getDropdownCollegeWidget(model.getColleges()))),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    icon: Icon(Icons.arrow_right_alt),
                    label: Text("GO!"),
                    onPressed: _submit,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showAddCollegeDialog({BuildContext context}) async {
    String _collegeName = "";
    final GlobalKey<FormState> _addCollegeformKey = GlobalKey();
    bool _isAdding = false;
    Future<void> Function() _onSubmitCollege = () async {
      if (_addCollegeformKey.currentState.validate()) {
        bool retVal = await _userViewModel.createCollege(name: _collegeName);
        if (retVal) {
          retVal = await _userViewModel.fetchAllColleges();
        }
        if (retVal) Navigator.pop(context);
      }
    };
    await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, dialogSetState) => AlertDialog(
                title: Text("Add College"),
                content: Form(
                  key: _addCollegeformKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'College Name',
                        labelStyle: TextStyle(fontSize: 15)),
                    validator: (val) {
                      if (val.trim().isEmpty) return "Cannot be empty";
                    },
                    onChanged: (val) {
                      _collegeName = val.trim();
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("CANCEL"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if (_isAdding)
                    CircularProgressIndicator()
                  else
                    TextButton(
                      child: Text("ADD"),
                      onPressed: () async {
                        dialogSetState(() {
                          _isAdding = true;
                        });
                        await _onSubmitCollege();
                        dialogSetState(() {
                          _isAdding = false;
                        });
                      },
                    )
                ],
              ),
            ));
  }
}
