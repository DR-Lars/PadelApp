import 'location.dart';
class Field {
  final String id;
  final String image;
  final Location location;
  final String name;
  Field({required this.id, required this.image, required this.location, required this.name});
  @override
  String toString(){
    return 'Field{id: $id, image: $image, location: $location, name: $name}';
  }
}