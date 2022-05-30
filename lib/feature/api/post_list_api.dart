import 'package:dio/dio.dart';
import 'package:task_rahmanda_one/model/post_model.dart';
import 'package:task_rahmanda_one/utils/network_util.dart';
import 'package:task_rahmanda_one/utils/string_util.dart';

class PostListApi {
  PostListModel postListModel = PostListModel();
  UrlString urlString = UrlString();
  StringUtils stringUtils = StringUtils();
  Dio dio = Dio();

  Future<PostListModel> getPostListApi(int limit) async {
    final Map<String, String> header =
        urlString.getHeaderType(stringUtils.appId);
    return await dio
        .get(urlString.getUrlPostList(limit),
            options: Options(headers: header))
        .then((dynamic res) {
      postListModel = PostListModel.fromJson(res.data);
      return postListModel;
    });
  }
}
