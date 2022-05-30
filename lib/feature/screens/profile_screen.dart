import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ds_bfi/flutter_ds_bfi.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:task_rahmanda_one/arguments/arguments_user_post.dart';
import 'package:task_rahmanda_one/bloc/post_porfile_bloc/bloc.dart';
import 'package:task_rahmanda_one/bloc/profile_bloc/bloc.dart';
import 'package:task_rahmanda_one/model/post_profile_model.dart';
import 'package:task_rahmanda_one/model/profile_model.dart';
import 'package:task_rahmanda_one/repositories/post_profile_repo.dart';
import 'package:task_rahmanda_one/repositories/profile_repo.dart';
import 'package:task_rahmanda_one/widget/no_connection.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.userId);

  final String userId;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc profileBloc = ProfileBloc(profileRepo: ProfileRepo());
  ProfileModel profileModel = ProfileModel();
  List<Data> dataPostProfile;
  PostProfileBloc postProfileBloc =
      PostProfileBloc(postProfileRepo: PostProfileRepo());
  bool noConnection = false, isLoading = false, hasReachedMax = false;
  int _page = 1;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    profileBloc.close();
    postProfileBloc.close();
    super.dispose();
  }

  Future<void> _getData() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      profileBloc.add(GetProfile(widget.userId));
      postProfileBloc.add(GetPostProfile(widget.userId, 10));
    } else {
      setState(() {
        noConnection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DSText(
                  data: 'Profile',
                  textStyle: DSTextStyle.titleTextStyle,
                ),
              ),
            ),
            preferredSize: const Size.fromHeight(26.0)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: const <Widget>[
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text('Back',
                    style: TextStyle(color: Colors.black, fontSize: 14))
              ],
            ),
          ),
        ),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: noConnection == true
          ? NoConnection(
              onTap: () {
                setState(() {
                  noConnection = false;
                });
                _getData();
              },
            )
          : BlocListener<ProfileBloc, ProfileState>(
              cubit: profileBloc,
              listener: (_, ProfileState state) {
                if (state is ProfileLoading) {
                  setState(() {
                    noConnection = false;
                  });
                }
                if (state is ProfileLoaded) {
                  setState(() {
                    profileModel = state.profileModel;
                    noConnection = false;
                  });
                }
                if (state is ProfileError) {
                  setState(() {
                    noConnection = true;
                  });
                }
              },
              child: BlocListener<PostProfileBloc, PostProfileState>(
                cubit: postProfileBloc,
                listener: (_, PostProfileState state) {
                  if (state is PostProfileLoading) {
                    setState(() {
                      noConnection = false;
                      isLoading = true;
                    });
                  }
                  if (state is PostProfileLoaded) {
                    setState(() {
                      noConnection = false;
                      dataPostProfile = state.dataPostProfile;
                      isLoading = false;
                      hasReachedMax = state.hasReachedMax;
                    });
                  }
                  if (state is PostProfileError) {
                    setState(() {
                      noConnection = true;
                      isLoading = false;
                    });
                  }
                },
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  cubit: profileBloc,
                  builder: (_, ProfileState state) {
                    if (state is ProfileLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ProfileLoaded) {
                      return _mainProfile(context);
                    }
                    if (state is ProfileError) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container();
                  },
                ),
              )),
    );
  }

  Widget _mainProfile(BuildContext context) {
    final DateTime date =
        DateFormat('yyyy-MM-dd').parse(profileModel.dateOfBirth);
    final String birth = tanggal(date);
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(profileModel.picture),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Center(
            child: DSText(
              data: '${profileModel.firstName} ${profileModel.lastName}',
              textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: DSText(
              data: birth,
              textStyle: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: DSText(
                textAlign: TextAlign.center,
                data:
                    '${profileModel.location.state}, ${profileModel.location.country}',
                textStyle: TextStyle(
                    fontSize: 15, color: Colors.grey, fontFamily: 'Poppins')),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            height: hasReachedMax
                ? MediaQuery.of(context).size.height * 0.5
                : MediaQuery.of(context).size.height * 0.45,
            child: SingleChildScrollView(
              child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(keepScrollOffset: false),
                  children: dataPostProfile.map((dynamic item) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/detai-post-screen',
                            arguments: ArgumentsUserPost(
                                picture: item.owner.picture,
                                firstName: item.owner.firstName,
                                lastName: item.owner.lastName,
                                publishDate: item.publishDate,
                                image: item.image,
                                text: item.text,
                                likes: item.likes,
                                id: item.id,
                                idUser: item.owner.id,
                                tags: item.tags,
                                title: item.owner.title));
                      },
                      child: Container(
                          width: 100,
                          height: 100,
                          child: Image(
                            image: NetworkImage(item.image),
                            fit: BoxFit.cover,
                          )),
                    );
                  }).toList()),
            ),
          ),
          if (isLoading)
            Center(
                child: Container(
                    height: 20,
                    width: 20,
                    child: Theme(
                        data: ThemeData(accentColor: Colors.white),
                        child: const CircularProgressIndicator())))
          else
            Visibility(
              visible: hasReachedMax,
              child: DSNudedButton(
                  buttonState: DSButtonState.Active,
                  text: 'Muat lebih banyak',
                  fontSize: 14.0,
                  color: DSColor.secondaryOrange,
                  onTap: () {
                    setState(() {
                      isLoading = true;
                      _page++;
                      dataPostProfile.clear();
                    });
                    postProfileBloc
                        .add(GetPostProfile(widget.userId, 10 * _page));
                  }),
            ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
