import 'location.dart';
class Field {
  final String id;
  final String image;
  final Location location;
  final String name;
  final String address;
  final int openingsUur;
  final int sluitingsUur;
  final List<Reservations> reservations;

  Field({required this.id, required this.image, required this.location, required this.name, required this.address, required this.openingsUur, required this.sluitingsUur, required this.reservations});

  @override
  String toString() {
    return 'Field{id: $id, image: $image, location: $location, name: $name, address: $address, reservations: $reservations}';
  }

}

class Reservations {
  final String date;
  final List<TimeSlot> time;

  Reservations({required this.date, required this.time});

  @override
  String toString() {
    return 'Reservation{date: $date, TimeSlot: $time}';
  }

}

class TimeSlot {
  final String time;
  final List<String> users;

  TimeSlot({required this.time, required this.users});

  DateTime toDateTime(){
    List<String> timeArray = time.split(":");
    return DateTime(0,0,0,int.parse(timeArray[0]),int.parse(timeArray[1]));
  }

  @override
  String toString() {
    return 'TimeSlot{time: $time, users: $users}';
  }

}