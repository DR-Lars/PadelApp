import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padel_application/models/user.dart';

Future<List<UserModel>> fetchUsers() async{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  List<UserModel> result = [];
  await users.get()
    .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        final data = doc.data() as Map;
        final UserModel user = new UserModel(id: doc.id, email: data['email'], userName: data['username'], gender: data['gender'], phone: data['phone'], password: data['password'], location: new Location(latitude: data['location'].latitude, longitude: data['location'].longitude), bio: data['bio'], level: data['level']);
        result.add(user);
      });
    })
      .catchError((error) => print("Failed to fetch users: $error"));
  return result;
}

Future<void> addUser(String name, String email, String password) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  
  return users.add({
    'name': name,
    'email': email,
    'password': password,
  })
  .then((value) => print("User added successfully!"))
  .catchError((error) => print("Failed to add user: $error"));
}

Future<void> fetchFields() {
  CollectionReference fields = FirebaseFirestore.instance.collection('fields');
  
  return fields.get()
    .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    })
    .catchError((error) => print("Failed to fetch users: $error"));
}