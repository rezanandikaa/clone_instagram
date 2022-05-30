import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_rahmanda_one/model/comment_list_model.dart';
import 'package:task_rahmanda_one/repositories/comment_list_repo.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  CommentListBloc({@required this.commentListRepo})
      : assert(commentListRepo != null),
        super(CommentListEmpty());

  final CommentListRepo commentListRepo;
  CommentListModel commentListModel;

  @override
  Stream<Transition<CommentListEvent, CommentListState>> transformEvents(
    Stream<CommentListEvent> events,
    TransitionFunction<CommentListEvent, CommentListState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  bool _hasReachedMax(CommentListState state) =>
      state is CommentListLoaded && state.hasReachedMax;

  @override
  Stream<CommentListState> mapEventToState(
    CommentListEvent event,
  ) async* {
    final CommentListState currentState = state;
    if (event is GetCommentList && !_hasReachedMax(currentState)) {
      yield CommentListLoading();
      try {
        if (currentState is CommentListEmpty) {
          commentListModel =
              await commentListRepo.getCommentList(event.postId, event.limit);
          if (commentListModel.data != null) {
            yield CommentListLoaded(
                dataCommentList: commentListModel.data, hasReachedMax: false);
          } else {
            yield CommentListError('no_data');
          }

          return;
        }
        if (currentState is CommentListLoaded) {
          commentListModel =
              await commentListRepo.getCommentList(event.postId, event.limit);
          yield commentListModel.data == null
              ? currentState.copyWith(hasReachedMax: true)
              : CommentListLoaded(
                  dataCommentList:
                      currentState.dataCommentList + commentListModel.data,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        yield const CommentListError('error');
      }
    }
  }
}
