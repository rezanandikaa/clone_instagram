class CommentListModel {
  List<Data> data;
  int total;
  int page;
  int limit;

  CommentListModel({this.data, this.total, this.page, this.limit});

  CommentListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}

class Data {
  String id;
  String message;
  Owner owner;
  String post;
  String publishDate;

  Data({this.id, this.message, this.owner, this.post, this.publishDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    post = json['post'];
    publishDate = json['publishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['post'] = this.post;
    data['publishDate'] = this.publishDate;
    return data;
  }
}

class Owner {
  String id;
  String title;
  String firstName;
  String lastName;
  String picture;

  Owner({this.id, this.title, this.firstName, this.lastName, this.picture});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['picture'] = this.picture;
    return data;
  }
}