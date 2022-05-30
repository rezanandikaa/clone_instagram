import 'package:dio/dio.dart';
import 'package:task_rahmanda_one/model/post_profile_model.dart';
import 'package:task_rahmanda_one/utils/network_util.dart';
import 'package:task_rahmanda_one/utils/string_util.dart';

class PostProfileApi {
  PostProfileModel postProfileModel = PostProfileModel();
  UrlString urlString = UrlString();
  StringUtils stringUtils = StringUtils();
  Dio dio = Dio();

  Future<PostProfileModel> getUserPost(String userId, int limit) async {
    final Map<String, String> header =
        urlString.getHeaderType(stringUtils.appId);
    return await dio
        .get(urlString.getUrlUserPost(userId, limit),
            options: Options(headers: header))
        .then((dynamic res) {
      postProfileModel = PostProfileModel.fromJson(res.data);
      return postProfileModel;
    });
  }
}
