import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'start_screen.dart';
import 'package:padel_application/services/database_connection.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isValid = true;
  String _errorMessage = '';

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  double padding(){
    switch(MediaQuery.of(context).size.width){
      case >1600:
        return 700;
      case >800:
        return 300;
      default:
        return 20;
    }
  }

  void _login() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const StartScreen()));
  }
  Future<void> _register() async{
    var temp = await fetchUsers();
    setState(() {
      _isValid = _validate(password.text, username.text, email.text);
    });
    if(_isValid){
      bool found = false;
      for (var user in temp) {
        if(user.userName == username.text || user.email == email.text){
          found = true;
          if(user.userName == username.text){
            _errorMessage = 'This username is already in use';
          }
          if(user.email == email.text) {
            _errorMessage += 'This email is already in use';
          }
        }
      }
      if(found){
        setState(() {
          _isValid = false;
        });
      } else {
        String encryptedPassword = encryptPassword(password.text);
        final userId = await addUser(username.text, email.text, encryptedPassword);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(id: userId))
        );
      }
    }
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
          title: const Text('Padleomic'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding()),
          child: Center(
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
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                  ),

                  // Display the result of password validation
                  _isValid ? const Text('') : Text(_errorMessage, style: const TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: _login,
                    child: const Text('Sing in'),
                  ),
                ]),
          ),
        )
    );
  }
  bool _validate(String password, String username, String email) {
    // Reset error message
    _errorMessage = '';

    // Password length greater than 6
    if (password.length <6) {
      _errorMessage += 'Password must be longer than 6 characters.\n';
    }

    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }

    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }

    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
    }

    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _errorMessage += '• Special character is missing.\n';
    }
    if (username.length < 4){
      _errorMessage += '• Username must be longer than 4 characters.\n';
    }

    if (!email.contains(RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$'))){
      _errorMessage += '• Invalid email.\n';
    }

    // If there are no error messages, the password is valid
    return _errorMessage.isEmpty;
  }
}
