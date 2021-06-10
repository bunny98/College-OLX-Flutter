import 'package:ent_new/Api/api.dart';
import 'package:ent_new/Api/api_interface.dart';
import 'package:ent_new/Api/fakeApi.dart';

import '../constants.dart';

class Repository {
  ApiI api;

  Repository(){
    api = USE_FAKE_API ? FakeApi() : Api.getInstance();  //SINGLETON OBJ OF "API" TO PREVENT REPEATED DIO INITIALISATIONS
  }

  bool isSuccessResponse(Map<String, dynamic> response) {
    return response[API_RESPONSE_KEY] != API_FAILED_RESPONSE;
  }
}