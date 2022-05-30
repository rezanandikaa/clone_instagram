import 'package:equatable/equatable.dart';
import 'package:task_rahmanda_one/model/comment_list_model.dart';

abstract class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object> get props => [];
}

class CommentListEmpty extends CommentListState {}

class CommentListLoading extends CommentListState {}

class CommentListLoaded extends CommentListState {
  const CommentListLoaded({this.hasReachedMax, this.dataCommentList});

  final List<Data> dataCommentList;
  final bool hasReachedMax;

  CommentListLoaded copyWith({
    List<Data> posts,
    bool hasReachedMax,
  }) {
    return CommentListLoaded(
      dataCommentList: posts ?? dataCommentList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataCommentList, hasReachedMax];
}

class CommentListError extends CommentListState {
  const CommentListError(this.error) : assert(error != null);

  final String error;

  @override
  List<Object> get props => [error];
}
