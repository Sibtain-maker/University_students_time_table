import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://swuiljmyleyfhirxnbvx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN3dWlsam15bGV5ZmhpcnhuYnZ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MzM3MjUsImV4cCI6MjA3MzEwOTcyNX0.QjDwA9m8piq6DHQYPSYOZiRDVvVAab76rMhqOgi4lyc',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("My First App")),
        body: Center(child: Text("Hello World")),
      ),
    );
  }
}
