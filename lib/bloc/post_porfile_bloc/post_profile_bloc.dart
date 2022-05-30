import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_rahmanda_one/model/post_profile_model.dart';
import 'package:task_rahmanda_one/repositories/post_profile_repo.dart';
import 'bloc.dart';
import 'package:rxdart/rxdart.dart';

class PostProfileBloc extends Bloc<PostProfileEvent, PostProfileState> {
  PostProfileBloc({@required this.postProfileRepo})
      : assert(postProfileRepo != null),
        super(PostProfileEmpty());

  final PostProfileRepo postProfileRepo;
  PostProfileModel postProfileModel;

  @override
  Stream<Transition<PostProfileEvent, PostProfileState>> transformEvents(
    Stream<PostProfileEvent> event,
    TransitionFunction<PostProfileEvent, PostProfileState> transitionFn,
  ) {
    return super.transformEvents(
      event.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  bool _hasReachedMax(PostProfileState state) =>
      state is PostProfileLoaded && state.hasReachedMax;

  @override
  Stream<PostProfileState> mapEventToState(
    PostProfileEvent event,
  ) async* {
    final PostProfileState currentState = state;
    if (event is GetPostProfile && !_hasReachedMax(currentState)) {
      yield PostProfileLoading();
      try {
        if (currentState is PostProfileEmpty) {
          postProfileModel =
              await postProfileRepo.getUserPost(event.userId, event.limit);
          if (postProfileModel.data != null) {
            yield PostProfileLoaded(
                dataPostProfile: postProfileModel.data, hasReachedMax: false);
          } else {
            yield PostProfileError('no_data');
          }

          return;
        }
        if (currentState is PostProfileLoaded) {
          postProfileModel =
              await postProfileRepo.getUserPost(event.userId, event.limit);
          yield postProfileModel.data == null
              ? currentState.copyWith(hasReachedMax: true)
              : PostProfileLoaded(
                  dataPostProfile:
                      currentState.dataPostProfile + postProfileModel.data,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        yield const PostProfileError('error');
      }
    }
  }
}
