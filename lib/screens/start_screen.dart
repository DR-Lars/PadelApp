import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:padel_application/services/database_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future<void> _login() async {
    var temp = await fetchUsers();
    print(temp);

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => const HomeScreen(title: "Home screen")));
  }

  void _register() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen(title: "Home screen")));
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
        // Here we take the value from the StartScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Padleomic'),
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
              TextButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ]),
      ),
    );
  }
}
