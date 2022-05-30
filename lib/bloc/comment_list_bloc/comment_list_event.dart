import 'package:equatable/equatable.dart';

abstract class CommentListEvent extends Equatable {
  const CommentListEvent();

  @override
  List<Object> get props => [];
}

class GetCommentList extends CommentListEvent {
  const GetCommentList(this.postId, this.limit);

  final String postId;
  final int limit;

  @override
  List<Object> get props => [];
}
