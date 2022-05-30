import 'package:task_rahmanda_one/feature/api/post_profile_api.dart';
import 'package:task_rahmanda_one/model/post_profile_model.dart';

class PostProfileRepo {
  PostProfileApi postProfileApi = PostProfileApi();

  Future<PostProfileModel> getUserPost(String userId, int limit) =>
      postProfileApi.getUserPost(userId, limit);
}
