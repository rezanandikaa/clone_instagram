import 'package:equatable/equatable.dart';
import 'package:task_rahmanda_one/model/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profileModel);

  final ProfileModel profileModel;

  @override
  List<Object> get props => [profileModel];
}

class ProfileError extends ProfileState {
  const ProfileError(this.error) : assert(error != null);

  final String error;

  @override
  List<Object> get props => [error];
}
