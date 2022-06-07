import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:indonesia/indonesia.dart';
import 'package:intl/intl.dart';
import 'package:task_rahmanda_one/arguments/arguments_user_post.dart';
import 'package:task_rahmanda_one/bloc/comment_list_bloc/bloc.dart';
import 'package:task_rahmanda_one/model/comment_list_model.dart';
import 'package:task_rahmanda_one/repositories/comment_list_repo.dart';
import 'package:task_rahmanda_one/widget/no_connection.dart';

class DetailPostScreen extends StatefulWidget {
  const DetailPostScreen(this.argumentsUserPost);
  final ArgumentsUserPost argumentsUserPost;
  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  String tgl = '';
  int total = 0;
  bool noConnection = false;

  CommentListBloc commentListBloc =
      CommentListBloc(commentListRepo: CommentListRepo());
  List<Data> dataCommentList = [];

  @override
  void initState() {
    DateTime dates =
        DateFormat('yyyy-MM-dd').parse(widget.argumentsUserPost.publishDate);
    dates.add(Duration(days: 10, hours: 5));
    tgl = tanggal(dates);
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      commentListBloc.add(GetCommentList(widget.argumentsUserPost.id, 10));
    } else {
      setState(() {
        noConnection = true;
      });
    }
  }

  @override
  void dispose() {
    commentListBloc.close();
    super.dispose();
  }

  void _showButtomComment() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Comment',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 16.0);
                      },
                      itemCount: dataCommentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/profile-screen',
                                            arguments: dataCommentList[index]
                                                .owner
                                                .id);
                                      },
                                      child: Text(
                                        '${dataCommentList[index].owner.firstName} ${dataCommentList[index].owner.lastName}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      dataCommentList[index].message,
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 200,
              height: 200,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Back',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        titleSpacing: 0.0,
        automaticallyImplyLeading: true,
        leadingWidth: 220,
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
          : BlocListener<CommentListBloc, CommentListState>(
              cubit: commentListBloc,
              listener: (_, CommentListState state) {
                if (state is CommentListLoading) {
                  setState(() {
                    noConnection = false;
                  });
                }
                if (state is CommentListLoaded) {
                  setState(() {
                    noConnection = false;
                    dataCommentList = state.dataCommentList;
                    total = state.dataCommentList.length;
                  });
                }
                if (state is CommentListError) {
                  setState(() {
                    noConnection = true;
                  });
                }
              },
              child: BlocBuilder<CommentListBloc, CommentListState>(
                cubit: commentListBloc,
                builder: (_, CommentListState state) {
                  if (state is CommentListLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is CommentListLoaded) {
                    return _mainDetailPost(context);
                  }
                  if (state is CommentListError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container();
                },
              ),
            ),
    );
  }

  Widget _mainDetailPost(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 1.2,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(widget.argumentsUserPost.picture),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.argumentsUserPost.firstName} ${widget.argumentsUserPost.lastName}',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 6,
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
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Text(
                widget.argumentsUserPost.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image(
                image: NetworkImage(widget.argumentsUserPost.image),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
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
                        '${widget.argumentsUserPost.likes.toString()} People',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                dataCommentList.length == 0
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mode_comment_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '0 People',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ],
                      )
                    : Container(
                        child: InkWell(
                          onTap: () {
                            _showButtomComment();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${total.toString()} People',
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
