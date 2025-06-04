import 'dart:math';
import 'package:flutter/material.dart';
import '../data/questions.dart';
import 'questions_number.dart';

class HomeScreen extends StatefulWidget {
  final int questionCount;

  const HomeScreen({super.key, required this.questionCount});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, Object>> _shuffledQuestions;
  int _questionIndex = 0;
  int _score = 0;
  bool _showResult = false;

  int? _answeredIndex;
  bool _answered = false;
  late List<Map<String, Object>> _shuffledAnswers;

  @override
  void initState() {
    super.initState();
    _shuffledQuestions = List.from(questions);
    _shuffledQuestions.shuffle(Random());

    // Limita ao número de perguntas escolhidas pelo usuário
    if (widget.questionCount < _shuffledQuestions.length) {
      _shuffledQuestions = _shuffledQuestions.sublist(0, widget.questionCount);
    }

    _embaralharRespostas();
  }

  void _embaralharRespostas() {
    final respostasOriginais = _shuffledQuestions[_questionIndex]['respostas'] as List<Map<String, Object>>;
    _shuffledAnswers = List<Map<String, Object>>.from(respostasOriginais);
    _shuffledAnswers.shuffle(Random());
  }

  void _responder(int index, bool correta) {
    if (_answered) return;

    setState(() {
      _answeredIndex = index;
      _answered = true;
      if (correta) _score++;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        if (_questionIndex + 1 < _shuffledQuestions.length) {
          _questionIndex++;
          _answeredIndex = null;
          _answered = false;
          _embaralharRespostas();
        } else {
          _showResult = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themePrimary = Colors.deepPurple;
    final themeSecondary = Colors.deepPurpleAccent;

    if (_showResult) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Resultado'),
          backgroundColor: themePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Você acertou $_score de ${_shuffledQuestions.length}!',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SelectNumberScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Recomeçar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pergunta = _shuffledQuestions[_questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Cultura Pop'),
        backgroundColor: themePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: themeSecondary.withOpacity(0.1),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  pergunta['pergunta'].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ..._shuffledAnswers.asMap().entries.map((entry) {
              int idx = entry.key;
              Map<String, Object> resp = entry.value;

              Color btnColor = Colors.deepPurple.shade100;
              Color textColor = Colors.black87;

              if (_answeredIndex == idx) {
                if (resp['correta'] as bool) {
                  btnColor = Colors.green.shade400;
                  textColor = Colors.white;
                } else {
                  btnColor = Colors.red.shade400;
                  textColor = Colors.white;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _responder(idx, resp['correta'] as bool),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    resp['texto'].toString(),
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                ),
              );
            }),
            const Spacer(),
            Text(
              'Pergunta ${_questionIndex + 1} de ${_shuffledQuestions.length}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
