import 'package:ent_new/constants.dart';
import 'package:ent_new/models/college.dart';
import 'package:ent_new/models/user.dart';
import 'package:ent_new/repository/base_repository.dart';

class UserRepository extends Repository {
  Future<User> createUser(
      {String name, String collegeId, String mobNum}) async {
    Map<String, dynamic> response =
        await api.createUser(name: name, collegeId: collegeId, mobNum: mobNum);
    return isSuccessResponse(response)
        ? User.fromMap(response[API_RESPONSE_KEY])
        : null;
  }

  Future<User> getUserById({String id}) async {
    Map<String, dynamic> response = await api.getUserById(id: id);
    return isSuccessResponse(response)
        ? User.fromMap(response[API_RESPONSE_KEY])
        : null;
  }

  Future<List<College>> getAllColleges() async {
    Map<String, dynamic> response = await api.getAllColleges();
    return isSuccessResponse(response)
        ? (response[API_RESPONSE_KEY] as List)
            .map((college) => College.fromMap(college))
            .toList()
        : null;
  }

  Future<College> createCollege({String name}) async {
    Map<String, dynamic> response = await api.createCollege(name: name);
    return isSuccessResponse(response)
        ? College.fromMap(response[API_RESPONSE_KEY])
        : null;
  }
}
