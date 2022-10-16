import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = ""; //user's response will be assigned to this variable
  String final_response = "";
  final _formkey =
      GlobalKey<FormState>(); //key created to interact with the form
  final url = 'https://mentalhealthchatbotapi.herokuapp.com/';

  //function to validate and save user form
  Future<void> _savingData() async {
    final validation = _formkey.currentState!.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState!.save();
  }

  //function to add border and rounded edges to our form
  OutlineInputBorder _inputformdeco() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
          width: 1.0,
          color: Color.fromARGB(255, 8, 51, 87),
          style: BorderStyle.solid),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              Container(
                margin: EdgeInsets.all(15),
                width: 350,
                child: Form(
                  key: _formkey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter query here',
                      enabledBorder: _inputformdeco(),
                      focusedBorder: _inputformdeco(),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 49, 222, 167),
                      elevation: 10),
                  onPressed: () async {
                    //validating the form and saving it
                    _savingData();

                    //url to send the post request to

                    //sending a post request to the url
                    final response = await http.post(Uri.parse(url),
                        body: json.encode({'name': name}));
                  },
                  child: Text('Post question'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 22, 118, 213),
                      elevation: 14),
                  onPressed: () async {
                    //url to send the get request to

                    //getting data from the python server script and assigning it to response
                    final response = await http.get(Uri.parse(url));

                    //converting the fetched data from json to key value pair that can be displayed on the screen
                    final decoded =
                        json.decode(response.body) as Map<String, dynamic>;

                    //changing the UI be reassigning the fetched data to final response
                    setState(() {
                      final_response = decoded['name'];
                    });
                  },
                  child: Text('Get answer'),
                ),
              ),

              //displays the data on the screen
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  borderOnForeground: true,
                  elevation: 15,
                  color: Color.fromARGB(255, 233, 230, 227),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    // padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        final_response,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
