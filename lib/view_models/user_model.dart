import 'package:ent_new/constants.dart';
import 'package:ent_new/models/college.dart';
import 'package:ent_new/models/user.dart';
import 'package:ent_new/repository/orders_repository.dart';
import 'package:ent_new/repository/user_repository.dart';
import 'package:ent_new/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  static UserViewModel _uniqueInstance;

  UserRepository _userRepository;
  User _currUser;
  College _currCollege;
  List<College> _colleges;

  UserViewModel._() {
    _userRepository = UserRepository();
    _currCollege = College.init();
  }

  static UserViewModel getInstance() {
    if (_uniqueInstance == null) {
      _uniqueInstance = UserViewModel._();
    }
    return _uniqueInstance;
  }

  User getCurrUser() => _currUser;

  List<College> getColleges() => _colleges;

  College getCurrCollege() => _currCollege;

  set setCurrCollege(College college) {
    this._currCollege = college;
  }

  Future<bool> onStartUp() async {
    await MySharedPrefs.init();
    await fetchAllColleges();
    if (MySharedPrefs.isPresent()) {
      return await signIn(userId: MySharedPrefs.getUserId());
    }
    return false;
  }

  Future<void> signOut() async {
    _currUser = null;
    _currCollege = College.init();
    await MySharedPrefs.removeUser();
  }

  Future<bool> signIn({String userId}) async {
    print("SIGN IN USERID $userId");
    User user = await _userRepository.getUserById(id: userId);
    if (user != null) {
      if (USE_FAKE_API) {
        _userRepository.api.getNotifications(userId: userId);
        _currCollege = College.init();
      } else {
        _currCollege = _colleges
            .firstWhere((element) => element.id == _currUser.collegeId);
      }
      _currUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp({String name, String collegeId, String mobNum}) async {
    User user = await _userRepository.createUser(
        name: name, collegeId: collegeId, mobNum: mobNum);
    if (user != null) {
      if (USE_FAKE_API) {
        _userRepository.api.getNotifications(userId: user.id);
      }
      _currUser = user;
      await MySharedPrefs.setUserId(userId: _currUser.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> fetchAllColleges() async {
    List<College> colleges = await _userRepository.getAllColleges();
    if (colleges != null) {
      _colleges = colleges;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createCollege({String name}) async {
    College college = await _userRepository.createCollege(name: name);
    if (college != null) {
      _currCollege = college;
      notifyListeners();
      return true;
    }
    return false;
  }
}
