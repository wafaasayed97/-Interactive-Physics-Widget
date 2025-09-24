import 'package:flutter/material.dart';
import 'package:interactive_physics_widget/intreactive_phsics_widget/ui/intreactive_phsics_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Physics',
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PhysicsSimulationWidget(),
    );
  }
}

