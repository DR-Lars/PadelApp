import 'location.dart';
class UserModel {
  final String id;
  final String email;
  final String userName;
  final int? gender;
  final String? phone;
  final String password;
  final Location? location;
  final String? bio;
  final int level;

  UserModel({ required this.id, required this.email, required this.userName, this.gender, this.phone, required this.password, this.location, this.bio, required this.level});
  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, userName: $userName, gender: $gender, phone: $phone, password: $password, location: $location, bio: $bio, level: $level}';
  }
}
