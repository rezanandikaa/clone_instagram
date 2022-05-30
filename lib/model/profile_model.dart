class ProfileModel {
  String id;
  String title;
  String firstName;
  String lastName;
  String picture;
  String gender;
  String email;
  String dateOfBirth;
  String phone;
  Location location;
  String registerDate;
  String updatedDate;

  ProfileModel(
      {this.id,
      this.title,
      this.firstName,
      this.lastName,
      this.picture,
      this.gender,
      this.email,
      this.dateOfBirth,
      this.phone,
      this.location,
      this.registerDate,
      this.updatedDate});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picture = json['picture'];
    gender = json['gender'];
    email = json['email'];
    dateOfBirth = json['dateOfBirth'];
    phone = json['phone'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    registerDate = json['registerDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['picture'] = this.picture;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['dateOfBirth'] = this.dateOfBirth;
    data['phone'] = this.phone;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['registerDate'] = this.registerDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}

class Location {
  String street;
  String city;
  String state;
  String country;
  String timezone;

  Location({this.street, this.city, this.state, this.country, this.timezone});

  Location.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['timezone'] = this.timezone;
    return data;
  }
}