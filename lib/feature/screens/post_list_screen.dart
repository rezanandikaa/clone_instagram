import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ds_bfi/flutter_ds_bfi.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:task_rahmanda_one/bloc/post_list_bloc/bloc.dart';
import 'package:task_rahmanda_one/model/post_model.dart';
import 'package:task_rahmanda_one/repositories/post_list_repo.dart';
import 'package:task_rahmanda_one/widget/custom_toast_widget.dart';
import 'package:task_rahmanda_one/widget/no_connection.dart';
import 'package:shimmer/shimmer.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  PostListBloc postListBloc = PostListBloc(postListRepo: PostListRepo());
  bool noConnection = false, isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    postListBloc.close();
    super.dispose();
  }

  Future<void> _getData() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      postListBloc.add(GetPostList(10));
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
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DSText(
                    data: 'Post List',
                    textStyle: DSTextStyle.titleTextStyle,
                  ),
                ),
              ),
              preferredSize: const Size.fromHeight(10.0)),
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
            : BlocListener<PostListBloc, PostListState>(
                cubit: postListBloc,
                listener: (_, PostListState state) {
                  if (state is PostListEmpty) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                  if (state is PostListLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  if (state is PostListLoaded) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                  if (state is PostListError) {
                    setState(() {
                      isLoading = false;
                      noConnection = true;
                    });
                  }
                },
                child: BlocBuilder<PostListBloc, PostListState>(
                  cubit: postListBloc,
                  builder: (_, PostListState state) {
                    if (state is PostListEmpty) {
                      return _loadingSkeleton();
                    }
                    if (state is PostListLoading) {
                      return _loadingSkeleton();
                    }
                    if (state is PostListLoaded) {
                      final List<Data> dataList = state.dataPostList;
                      if (dataList == null) {
                        return Center(
                          child: DSText(
                            data: 'No Data',
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                controller: _scrollController,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 4,
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: state.hasReachedMax
                                    ? dataList.length
                                    : dataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final DateTime dates =
                                      DateFormat('yyyy-MM-dd')
                                          .parse(dataList[index].publishDate);
                                  dates.add(Duration(days: 10, hours: 5));
                                  final String tgl = tanggal(dates);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 16.0,
                                        bottom: 16.0),
                                    child: _postListWidget(
                                        context, dataList, index, tgl),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (isLoading)
                              Center(
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: Theme(
                                          data: ThemeData(
                                              accentColor: Colors.white),
                                          child:
                                              const CircularProgressIndicator())))
                            else
                              Visibility(
                                visible: !state.hasReachedMax,
                                child: DSNudedButton(
                                    buttonState: DSButtonState.Active,
                                    text: 'Muat lebih banyak',
                                    fontSize: 14.0,
                                    color: DSColor.secondaryOrange,
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                        dataList.clear();
                                        _page++;
                                      });
                                      final ConnectivityResult
                                          connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();
                                      if (connectivityResult !=
                                          ConnectivityResult.none) {
                                        postListBloc
                                            .add(GetPostList(10 * _page));
                                      } else {
                                        showToastWidget(
                                            CustomToast(
                                              message:
                                                  'Error Connection, Please Try Again',
                                              backgroundColor: Colors.red,
                                              isSuccess: false,
                                            ),
                                            position: ToastPosition.top,
                                            duration:
                                                const Duration(seconds: 4));
                                        setState(() {
                                          noConnection = true;
                                        });
                                        _getData();
                                      }
                                    }),
                              ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (state.hasReachedMax)
                              Center(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  margin:
                                      const EdgeInsets.only(top: 16, bottom: 8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        primary: DSColor.secondaryOrange,
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const <Widget>[
                                        Icon(Icons.arrow_upward),
                                        Text('Balik ke atas'),
                                      ],
                                    ),
                                    onPressed: () {
                                      _scrollController.animateTo(
                                        0.0,
                                        curve: Curves.easeOut,
                                        duration:
                                            const Duration(milliseconds: 300),
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              Container()
                          ],
                        );
                      }
                    }
                    if (state is PostListError) {
                      return _loadingSkeleton();
                    }
                    return Container();
                  },
                )));
  }

  Widget _postListWidget(
      BuildContext context, List<Data> listData, int index, String tgl) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 12, left: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/profile-screen',
                    arguments: listData[index].owner.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage(listData[index].owner.picture),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${listData[index].owner.firstName} ${listData[index].owner.lastName}',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        tgl,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Image(
              image: NetworkImage(listData[index].image),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profile-screen',
                      arguments: listData[index].owner.id);
                },
                child: Container(
                  child: Text(
                    '${listData[index].owner.firstName} ${listData[index].owner.lastName}',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: MediaQuery.of(context).size.width * 0.579,
                child: Text(
                  listData[index].text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.04,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tags: ',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                    itemCount: listData[index].tags.length,
                    itemBuilder: (BuildContext context, int idx) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        constraints:
                            BoxConstraints(maxWidth: 150, maxHeight: 40),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          listData[index].tags[idx],
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.white),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.thumb_up_alt,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${listData[index].likes.toString()} People',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(width: double.infinity, height: 1, color: Colors.grey),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Like',
                      style:
                          GoogleFonts.poppins(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Comment',
                      style:
                          GoogleFonts.poppins(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.grey,
                      size: 25,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Share',
                      style:
                          GoogleFonts.poppins(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _loadingSkeleton() {
    return Column(
      children: [
        Expanded(
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.infinity,
                padding: const EdgeInsets.only(right: 12, left: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.11,
                            height: MediaQuery.of(context).size.height * 0.11,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.025,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        padding: EdgeInsets.only(top: 8.0),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.025,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.025,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Tags: ',
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 14),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      constraints: BoxConstraints(
                                          maxWidth: 40, maxHeight: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    )),
                                SizedBox(width: 8.0),
                                Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      constraints: BoxConstraints(
                                          maxWidth: 40, maxHeight: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    )),
                                SizedBox(width: 8.0),
                                Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      constraints: BoxConstraints(
                                          maxWidth: 150, maxHeight: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.thumb_up_alt,
                          color: Colors.blue,
                          size: 20,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.021,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                        width: double.infinity, height: 1, color: Colors.grey),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Like',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.grey,
                                size: 25,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Comment',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.grey,
                                size: 25,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Share',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DSNudedButton(
              buttonState: DSButtonState.Active,
              text: 'Muat lebih banyak',
              fontSize: 14.0,
              color: DSColor.secondaryOrange,
              onTap: () {}),
        ),
      ],
    );
  }
}
