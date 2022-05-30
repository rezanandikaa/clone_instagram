import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_rahmanda_one/model/profile_model.dart';
import 'package:task_rahmanda_one/repositories/profile_repo.dart';
import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({@required this.profileRepo})
      : assert(profileRepo != null),
        super(ProfileInitial());

  final ProfileRepo profileRepo;
  ProfileModel profileModel;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfile) {
      yield ProfileLoading();
      try {
        profileModel = await profileRepo.getProfile(event.userId);
        if (profileModel != null) {
          yield ProfileLoaded(profileModel);
        } else {
          yield ProfileError('no_data');
        }
      } catch (e) {
        yield ProfileError(e.toString());
      }
    }
  }
}
