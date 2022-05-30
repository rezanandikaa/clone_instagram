import 'package:equatable/equatable.dart';

abstract class PostListEvent extends Equatable {
  const PostListEvent();

  @override
  List<Object> get props => [];
}

class GetPostList extends PostListEvent {
  const GetPostList(this.limit);

  final int limit;

  @override
  List<Object> get props => [];
}
