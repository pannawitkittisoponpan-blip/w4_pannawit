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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const MyHomePage(title: 'โปรแกรมเพิ่มรายการขนม'),
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
          SizedBox(height: 10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 170, vertical: 10),
            ),
            onPressed: () => addSnack(),
            child: const Text("บันทึก"),
          ),
          SizedBox(height: 10,),
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

                    final doc = snapshot.data!.docs;

                    return GridView.builder(
                      padding: const EdgeInsets.all(10), // เพิ่มพื้นที่รอบขอบจอ
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9, // ปรับสัดส่วนแนวตั้ง-แนวนอนของ Card
                      ),
                      itemCount: doc.length,
                      itemBuilder: (context, index) {
                        final s = doc[index].data();

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SnackDetailPage(snack: s)),
                            );
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.greenAccent[100],
                                  child: Icon(Icons.cake, color: Colors.green[800], size: 35),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  s["snackName"],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${s["snackPrice"]} บาท",
                                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

class SnackDetailPage extends StatelessWidget {
  final snack;

  const SnackDetailPage({super.key, required this.snack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text("รายละเอียดขนม"),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.greenAccent,
                child: Icon(Icons.cake, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.fastfood, color: Colors.greenAccent),
                    title: const Text("ชื่อขนม"),
                    subtitle: Text(snack['snackName'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.category, color: Colors.greenAccent),
                    title: const Text("ประเภท"),
                    subtitle: Text(snack['snackType']),
                  ),
                  ListTile(
                    leading: const Icon(Icons.monetization_on, color: Colors.greenAccent),
                    title: const Text("ราคา"),
                    subtitle: Text("${snack['snackPrice']} บาท"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}