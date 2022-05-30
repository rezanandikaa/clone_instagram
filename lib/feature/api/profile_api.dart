import 'package:dio/dio.dart';
import 'package:task_rahmanda_one/model/profile_model.dart';
import 'package:task_rahmanda_one/utils/network_util.dart';
import 'package:task_rahmanda_one/utils/string_util.dart';

class ProfileApi {
  ProfileModel profileModel = ProfileModel();
  UrlString urlString = UrlString();
  StringUtils stringUtils = StringUtils();
  Dio dio = Dio();

  Future<ProfileModel> getProfileApi(String userId) async {
    final Map<String, String> header =
        urlString.getHeaderType(stringUtils.appId);
    return await dio
        .get(urlString.getUrlProfile(userId),
            options: Options(headers: header))
        .then((dynamic res) {
      profileModel = ProfileModel.fromJson(res.data);
      return profileModel;
    });
  }
}