import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padel_application/models/field.dart';
import 'package:padel_application/services/database_connection.dart';

class FieldDetailsScreen extends StatefulWidget {
  const FieldDetailsScreen({super.key, required this.id, required this.field});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String id;
  final Field field;

  @override
  State<FieldDetailsScreen> createState() => _FieldDetailsScreen();
}

class _FieldDetailsScreen extends State<FieldDetailsScreen> {
  DateTime date = DateTime.now();
  DateTime now = DateTime.now();
  DateTime? time;
  bool timeIsNull = true;
  List<Widget> generatedHours = [];

  @override
  void initState(){
    super.initState();
    generatedHours = generateHours();
  }

  bool isCurrentDate(DateTime date){
    return (date.month == this.date.month && date.day == this.date.day);
  }

  void changeDate(DateTime date){
    setState(() {
      this.date = date;
      generatedHours = generateHours();
    });
  }

  void changeTimestamp(DateTime time){
    setState(() {
      this.time = time;
      timeIsNull = false;
    });
  }

  List<Widget> generateHours(){
    List<Widget> result = [];
    List<DateTime> times = [];
    for(double i = double.parse(widget.field.openingsUur.toString()); i < widget.field.sluitingsUur; i+= 0.5){
      DateTime time = DateTime(0,0,0,i.floor(),i%1==0?0:30);
      times.add(time);
      result.add(TextButton(onPressed: (){changeTimestamp(time);}, child: Text(DateFormat.Hm().format(time))));
    }
    String newDate = DateFormat("dd/MM/yyyy").format(date);
    Reservations? reservation = widget.field.reservations.where((reservation)=> reservation.date == newDate).firstOrNull;
    if(reservation != null){
      for (TimeSlot value in reservation.time) {
        if(value.users.isNotEmpty){
          for(int i = 0; i < times.length; i++){
            if(DateFormat.Hm().format(times[i])== value.time){
              result.removeRange(i-2, i);
              result.removeRange(i-1, i+1);
              if(value.users.length == 4){
                result.removeRange(i-2, i-1);
              }
            }
          }
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the HomeScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Padleomic'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            onPressed: () {
              //TODO
            },
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications Icon',
            onPressed: () {
              //TODO
            },
          ), //IconButton
        ], //<Widget>[]
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: NetworkImage(widget.field.image)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.field.name)
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.field.address)
            ),
            SizedBox(
              height: 80.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:  List.generate(100, (int index) {
                    return  TextButton(
                        onPressed: (){changeDate(now.add(Duration(days: index)));},
                        style: isCurrentDate(now.add(Duration(days: index)))? TextButton.styleFrom(backgroundColor: Colors.pink): TextButton.styleFrom(backgroundColor: Colors.white),
                        child: Text("${DateFormat.E().format(now.add(Duration(days: index)))}\n${now.add(Duration(days: index)).day}\n${DateFormat.MMM().format(now.add(Duration(days: index)))}"
                        ),
                    );
                }),
              ),
            ),
            SizedBox(
              height: 80.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:  generatedHours,
              ),
            ),
            timeIsNull? const Text(""): Text("There are currently ${getPlayerAmount(date, time!)} players in the match"),
            timeIsNull? const Text(""): TextButton(onPressed: (){joinMatch(date, time!);},child: const Text("Click here to join"),)
          ]
        ),
      ),
    );
  }
  String getPlayerAmount(DateTime date, DateTime time) {
    String newDate = DateFormat("dd/MM/yyyy").format(date);
    Reservations? reservation = widget.field.reservations.where((reservation)=> reservation.date == newDate).firstOrNull;
    if(reservation != null){
      for (TimeSlot value in reservation.time) {
        return value.users.length.toString();
      }
    }
    return "0";
  }
  void joinMatch(DateTime date, DateTime time){
    String newDate = DateFormat("dd/MM/yyyy").format(date);
    Reservations? reservation =  widget.field.reservations.where((reservation)=> reservation.date == newDate).firstOrNull;
    if(reservation != null){
      for (TimeSlot timeSlot in reservation.time) {
        if(timeSlot.time == DateFormat.Hm().format(time)){
          timeSlot.users.add(widget.id);
        }
      }
    }else{
      widget.field.reservations.add(Reservations(date: newDate, time: [TimeSlot(time: DateFormat.Hm().format(time), users: [widget.id])]));
    }
    addReservation(widget.field);
  }
}