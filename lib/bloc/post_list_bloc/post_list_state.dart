import 'package:equatable/equatable.dart';
import 'package:task_rahmanda_one/model/post_model.dart';

abstract class PostListState extends Equatable {
  const PostListState();

  @override
  List<Object> get props => [];
}

class PostListEmpty extends PostListState {}

class PostListLoading extends PostListState {}

class PostListLoaded extends PostListState {
  const PostListLoaded({this.hasReachedMax, this.dataPostList});

  final List<Data> dataPostList;
  final bool hasReachedMax;

  PostListLoaded copyWith({
    List<Data> posts,
    bool hasReachedMax,
  }) {
    return PostListLoaded(
      dataPostList: posts ?? dataPostList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataPostList, hasReachedMax];
}

class PostListError extends PostListState {
  const PostListError(this.error) : assert(error != null);

  final String error;

  @override
  List<Object> get props => [error];
}
