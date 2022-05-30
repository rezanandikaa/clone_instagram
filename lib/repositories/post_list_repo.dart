import 'package:task_rahmanda_one/feature/api/post_list_api.dart';
import 'package:task_rahmanda_one/model/post_model.dart';

class PostListRepo {
  PostListApi postListApi = PostListApi();

  Future<PostListModel> getPostList(int limit) =>
      postListApi.getPostListApi(limit);
}
