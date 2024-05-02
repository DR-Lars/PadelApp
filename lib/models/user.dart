class UserModel {
final String id;
final String email;
final String? userName;
final int? gender;
final String? phone;
final String password;
final Location? location;
final String? bio;

UserModel({ required this.id, required this.email, this.userName, this.gender, this.phone, required this.password, this.location, this.bio});
}

class Location {
  var valX;
  var valY;
  Location({this.valX,this.valY});
}
