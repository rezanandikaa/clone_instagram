import 'package:task_rahmanda_one/feature/api/comment_list_api.dart';
import 'package:task_rahmanda_one/model/comment_list_model.dart';

class CommentListRepo {
  CommentListApi commentListApi = CommentListApi();

  Future<CommentListModel> getCommentList(String postId, int limit) =>
      commentListApi.getCommentListApi(postId, limit);
}
