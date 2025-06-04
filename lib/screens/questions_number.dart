import 'package:flutter/material.dart';
import 'package:flutter_trabalho2b/data/questions.dart';
import 'package:flutter_trabalho2b/screens/home_screen.dart';

class SelectNumberScreen extends StatefulWidget {
  const SelectNumberScreen({super.key});

  @override
  State<SelectNumberScreen> createState() => _SelectNumberScreenState();
}

class _SelectNumberScreenState extends State<SelectNumberScreen> {
  int _selectedNumber = 5; // default

  @override
  Widget build(BuildContext context) {
    final maxQuestions = questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha o número de questões'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quantas perguntas você quer responder?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: DropdownButton<int>(
                  value: _selectedNumber,
                  elevation: 4,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.deepPurple.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                  items: List.generate(maxQuestions, (i) => i + 1)
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Center(child: Text(e.toString())),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedNumber = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HomeScreen(
                          questionCount: _selectedNumber,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: Colors.deepPurple.shade300,
                  ),
                  child: Text(
                    'Começar Quiz',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
