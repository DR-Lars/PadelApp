import 'dart:convert';
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
      .catchError((error) => throw("Failed to fetch users: $error"));
  return result;
}

Future<UserModel> getUserById(String id) async {
  final users = await fetchUsers();
  for (var user in users) {
    if(user.id == id){
      return user;
    }
  }
  throw("User not found");
}

Future<String> addUser(String name, String email, String password) async{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  DocumentReference doc = await users.add({
    'username': name,
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
        final data = doc.data() as Map<String, dynamic>;
        Location location = Location(latitude: data['location'].latitude, longitude: data['location'].longitude);
        Map<String, dynamic> reservations = json.decode(data['reservations']);
        List<Reservations> reservationsList = [];
        reservations.forEach((date, value){
          Map<String, dynamic> timeSlots = value;
          List<TimeSlot> temp = [];
          timeSlots.forEach((key, value){
            List<String> stringValue = value.cast<String>();
            temp.add(TimeSlot(time: key, users: stringValue));
          });
          reservationsList.add(Reservations(date: date, time: temp));
        });
        final Field field = Field(id: doc.id, name: data['name'], location: location, image: data['image'], address: data['address'], openingsUur: data['openingsUur'], sluitingsUur: data['sluitingsUur'], reservations: reservationsList);
        result.add(field);
      }
    })
    .catchError((error) => throw("Failed to fetch fields: $error"));
  return result;
}

Future<Field> getFieldById(String id) async {
  final fields = await fetchFields();
  for (var field in fields) {
    if(field.id == id){
      return field;
    }
  }
  throw("Field not found");
}

Future<void> addReservation(Field field) async{
  String json = '{';
  for (Reservations value in field.reservations) {
    json += '"${value.date}":{';
    for (TimeSlot timeSlot in value.time){
      json += '"${timeSlot.time}":[';
      for (String user in timeSlot.users){
        json += '"$user",';
      }
      json = removeLast(json);
      json += '],';
    }
    json = removeLast(json);
    json += '},';
  }
  json = removeLast(json);
  json += '}';
  CollectionReference fields = FirebaseFirestore.instance.collection('fields');
  await fields.doc(field.id).update({"reservations": json});
}

String removeLast(String string){
  return string.substring(0, string.length -1);
}