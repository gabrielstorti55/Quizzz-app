import 'package:flutter/material.dart';
import 'package:flutter_trabalho2b/screens/questions_number.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SelectNumberScreen(),
    );
  }
}
