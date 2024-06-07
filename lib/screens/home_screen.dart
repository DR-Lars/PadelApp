import 'dart:core';
import 'package:flutter/material.dart';
import 'package:padel_application/changedLibrary/horizontalLazyList/flutter_lazy_listview.dart';
import 'package:padel_application/models/field.dart';
import 'package:padel_application/models/user.dart';
import 'package:padel_application/services/database_connection.dart';
import 'package:padel_application/screens/field_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.id});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String id;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fieldController = DataFeedController<Field>();
  final matchController = DataFeedController<Field>();

  _loadData() async {
    List<Field> fields = await fetchFields();
    fieldController.appendData(fields);
    List<Field> matches = [];
    matches = fields.where((field)=> field.reservations.isNotEmpty).toList();
    matchController.appendData(matches);
  }

  @override
  void initState(){
    super.initState();
    _loadData();
  }

  Widget _fieldCard(Field field){
    Offset offset = const Offset(0, 0);
    return Listener(
        onPointerDown: (PointerDownEvent e) =>
        {
          offset = e.position
        },
        onPointerUp: (PointerUpEvent e) =>{
          if(offset == e.position){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FieldDetailsScreen(id: widget.id, field: field)
                )
            )
          }
        },
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image(
                  image: NetworkImage(field.image),
                  height: 300,
                )),
            Text(field.name),
          ],
        )
    );
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Fields")
              ),
              Expanded(child: FlutterLazyListView<Field>(
                  dataFeedController: fieldController,
                  itemBuilder: (BuildContext context, Field field, int index){
                    return _fieldCard(field);
                  },
                  onReachingEnd: (){}
              )),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Matches")
              ),
              Expanded(child: FlutterLazyListView<Field>(
                  dataFeedController: matchController,
                  itemBuilder: (BuildContext context, Field field, int index){
                    return getFieldCard(field);
                  },
                  onReachingEnd: (){}
              ))
            ]),
      ),
    );
  }
  Widget getFieldCard(Field field) {
    return Column(children: [
      Text(field.name),
      Row(children: getDayCard(field.reservations, field))
    ]);
  }

  List<Widget> getDayCard(List<Reservations> reservations, Field field){
    List<Widget> result = [];
    for (Reservations reservation in reservations) {
      result.add(Column(
        children: [Padding(padding: const EdgeInsets.all(10) ,child: Text(reservation.date)),
      ...getTimeColumn(reservation, field)],));
    }
    return result;
  }

  List<Widget> getTimeColumn(Reservations reservation, Field field){
    List<Widget> result = [];
    for (TimeSlot timeSlot in reservation.time) {
      result.add(
          Listener(onPointerDown: (e){
            field.reservations.where((reservation2)=> reservation2.date == reservation.date).first.time.where((timeslot2)=> timeslot2.time == timeSlot.time).first.users.add(widget.id);
            addReservation(field);
          },
          child: Column(children: [Text(timeSlot.time),
            ...getUserColumn(timeSlot.users)],)));
    }
    return result;
  }

  List<Widget> getUserColumn(List<String> users){
    List<Widget> result = [];
    for (String user in users) {
      result.add(getUser(user));
    }
    return result;
  }
  Widget getUser(String userId){
    return FutureBuilder<UserModel>(
        future: getUserById(userId),
        builder: (context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.userName);
          } else {
            return const CircularProgressIndicator();
          }
        }
    );
  }
}
