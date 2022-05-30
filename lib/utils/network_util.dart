class UrlString {
  static String baseUrl = 'https://dummyapi.io/';

  static Map<String, String> headerType(String appId) => {
        'app-id': '$appId',
      };

  Map<String, String> getHeaderType(String appId) {
    return headerType(appId);
  }

  static urlPostList(int limit) => 'data/v1/post?limit=$limit';

  String getUrlPostList(int limit) {
    final String urlPostList2 = urlPostList(limit);
    return baseUrl + urlPostList2;
  }

  static urlProfile(String userId) => 'data/v1/user/$userId';

  String getUrlProfile(String userId) {
    final String urlProfile2 = urlProfile(userId);
    return baseUrl + urlProfile2;
  }

  static urlUserPost(String userId, int limit) =>
      'data/v1/user/$userId/post?limit=$limit';

  String getUrlUserPost(String userId, int limit) {
    final String urlUserPost2 = urlUserPost(userId, limit);
    return baseUrl + urlUserPost2;
  }

  static urlCommentList(String postId, int limit) =>
      'data/v1/post/$postId/comment?limit=$limit';

  String getUrlCommentList(String postId, int limit) {
    final String urlCommentList2 = urlCommentList(postId, limit);
    return baseUrl + urlCommentList2;
  }
}
