import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_rahmanda_one/model/post_model.dart';
import 'package:task_rahmanda_one/repositories/post_list_repo.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  PostListBloc({@required this.postListRepo})
      : assert(postListRepo != null),
        super(PostListEmpty());

  final PostListRepo postListRepo;
  PostListModel postListModel;

  @override
  Stream<Transition<PostListEvent, PostListState>> transformEvents(
    Stream<PostListEvent> events,
    TransitionFunction<PostListEvent, PostListState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  bool _hasReachedMax(PostListState state) =>
      state is PostListLoaded && state.hasReachedMax;

  @override
  Stream<PostListState> mapEventToState(
    PostListEvent event,
  ) async* {
    final PostListState currentState = state;
    if (event is GetPostList && !_hasReachedMax(currentState)) {
      yield PostListLoading();
      try {
        if (currentState is PostListEmpty) {
          postListModel = await postListRepo.getPostList(event.limit);
          if (postListModel.data != null) {
            yield PostListLoaded(
                dataPostList: postListModel.data, hasReachedMax: false);
          } else {
            yield PostListError('no_data');
          }

          return;
        }
        if (currentState is PostListLoaded) {
          postListModel = await postListRepo.getPostList(event.limit);
          yield postListModel.data == null
              ? currentState.copyWith(hasReachedMax: true)
              : PostListLoaded(
                  dataPostList: currentState.dataPostList + postListModel.data,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        yield const PostListError('error');
      }
    }
  }
}
