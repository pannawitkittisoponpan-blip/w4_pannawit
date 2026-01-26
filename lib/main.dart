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

  final _dessertNameCtrl = TextEditingController();
  final _dessertTypeCtrl = TextEditingController();
  final _dessertPriceCtrl = TextEditingController();

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
          controller: _dessertNameCtrl,
          ),
          TextField(decoration: InputDecoration(labelText: "ประเภทขนม : "),
            controller: _dessertTypeCtrl,
          ),
          TextField(decoration: InputDecoration(labelText: "ราคา : "),
            controller: _dessertPriceCtrl,
          ),
          ElevatedButton(onPressed: () => {}, child: Text("บันทึก"))
        ])),

    );
  }
}
