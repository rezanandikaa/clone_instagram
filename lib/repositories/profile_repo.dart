import 'package:task_rahmanda_one/feature/api/profile_api.dart';
import 'package:task_rahmanda_one/model/profile_model.dart';

class ProfileRepo {
  ProfileApi profileApi= ProfileApi();

  Future<ProfileModel> getProfile(String userId) =>
      profileApi.getProfileApi(userId);
}
