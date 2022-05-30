import 'package:equatable/equatable.dart';

abstract class PostProfileEvent extends Equatable {
  const PostProfileEvent();

  @override
  List<Object> get props => [];
}

class GetPostProfile extends PostProfileEvent {
  const GetPostProfile(this.userId, this.limit);

  final String userId;
  final int limit;

  @override
  List<Object> get props => [];
}
