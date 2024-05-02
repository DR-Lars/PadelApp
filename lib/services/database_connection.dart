import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fetchUsers() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  
  return users.get()
    .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    })
    .catchError((error) => print("Failed to fetch users: $error"));
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