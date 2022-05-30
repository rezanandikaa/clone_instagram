import 'package:dio/dio.dart';
import 'package:task_rahmanda_one/model/comment_list_model.dart';
import 'package:task_rahmanda_one/utils/network_util.dart';
import 'package:task_rahmanda_one/utils/string_util.dart';

class CommentListApi {
  CommentListModel commentListModel = CommentListModel();
  UrlString urlString = UrlString();
  StringUtils stringUtils = StringUtils();
  Dio dio = Dio();

  Future<CommentListModel> getCommentListApi(String postId, int limit) async {
    final Map<String, String> header =
        urlString.getHeaderType(stringUtils.appId);
    return await dio
        .get(urlString.getUrlCommentList(postId, limit),
            options: Options(headers: header))
        .then((dynamic res) {
      commentListModel = CommentListModel.fromJson(res.data);
      return commentListModel;
    });
  }
}