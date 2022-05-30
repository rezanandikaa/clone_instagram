import 'package:equatable/equatable.dart';
import 'package:task_rahmanda_one/model/post_profile_model.dart';

abstract class PostProfileState extends Equatable {
  const PostProfileState();

  @override
  List<Object> get props => [];
}

class PostProfileEmpty extends PostProfileState {}

class PostProfileLoading extends PostProfileState {}

class PostProfileLoaded extends PostProfileState {
  const PostProfileLoaded({this.hasReachedMax, this.dataPostProfile});

  final List<Data> dataPostProfile;
  final bool hasReachedMax;

  PostProfileLoaded copyWith({
    List<Data> posts,
    bool hasReachedMax,
  }) {
    return PostProfileLoaded(
      dataPostProfile: posts ?? dataPostProfile,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataPostProfile, hasReachedMax];
}

class PostProfileError extends PostProfileState {
  const PostProfileError(this.error) : assert(error != null);

  final String error;

  @override
  List<Object> get props => [error];
}
