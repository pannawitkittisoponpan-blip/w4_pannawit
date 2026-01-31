import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:  DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _snackNameCtrl = TextEditingController();
  final _snackTypeCtrl = TextEditingController();
  final _snackPriceCtrl = TextEditingController();

  void addSnack() async{
    String _name = _snackNameCtrl.text;
    String _type = _snackTypeCtrl.text;
    String _price = _snackPriceCtrl.text;

    print("test999 : $_name | $_type | $_price");

    try{

      await FirebaseFirestore.instance.collection("snacks").add({
        "snackName" : _name,
        "snackType" : _type,
        "snackPrice" : _price
      });

      _snackNameCtrl.clear();
      _snackTypeCtrl.clear();
      _snackPriceCtrl.clear();

    }catch(e){
      print("error : $e");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          TextField(decoration: InputDecoration(labelText: "ชื่อขนม : "),
          controller: _snackNameCtrl,
          ),
          TextField(decoration: InputDecoration(labelText: "ประเภทขนม : "),
            controller: _snackTypeCtrl,
          ),
          TextField(decoration: InputDecoration(labelText: "ราคา : "),
            controller: _snackPriceCtrl,
          ),
          ElevatedButton(onPressed: () => addSnack(), child: Text("บันทึก")),
        
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("snacks")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }

                    if(snapshot.hasError){
                      return Center(child: Text(snapshot.error.toString()),);
                    }

                    final snacks = snapshot.data!;

                    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                    ),
                        itemBuilder: itemBuilder,
                    );

                  },
              ),
          ),
        ],
        ),
      ),

    );
  }
}
