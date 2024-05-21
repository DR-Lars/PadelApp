import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padel_application/models/user.dart';
import 'package:padel_application/models/field.dart';
import 'package:padel_application/models/location.dart';

Future<List<UserModel>> fetchUsers() async{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<UserModel> result = [];
  await users.get()
    .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map;
        var location = null;
        if(data['location'] != null){
          location = Location(latitude: data['location'].latitude, longitude: data['location'].longitude);
        }
        final UserModel user = UserModel(id: doc.id, email: data['email'], userName: data['username'], gender: data['gender'], phone: data['phone'], password: data['password'], location: location, bio: data['bio'], level: data['level']);
        result.add(user);
      }
    })
      .catchError((error) => print("Failed to fetch users: $error"));
  return result;
}

Future<String> addUser(String name, String email, String password) async{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference doc = await users.add({
    'name': name,
    'email': email,
    'password': password,
    'level': 100,
  });
  return doc.id;
}

Future<List<Field>> fetchFields() async {
  CollectionReference fields = FirebaseFirestore.instance.collection('fields');
  List<Field> result = [];
  await fields.get()
    .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map;
        Location location = Location(latitude: data['location'].latitude, longitude: data['location'].longitude);
        final Field field = Field(id: doc.id, name: data['name'], location: location, image: data['image']);
        result.add(field);
      }
    })
    .catchError((error) => print("Failed to fetch users: $error"));
  return result;
}