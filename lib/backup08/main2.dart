import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int perguntaAtual = 1; // Número da pergunta atual
  String respostaUsuario = '';
  String respostaCorreta = 'print';
  Color appBarColor = Colors.blue; // Cor inicial da AppBar
  bool acertou = false;

  TextEditingController _textEditingController = TextEditingController();

  // Lista de perguntas e respostas
  List<Map<String, dynamic>> listaPerguntas = [
    {
      'pergunta':
          'Em python para imprimir um texto na tela complete o que falta.',
      'codigo': '?????(Hello World!!!)',
      'respostaCorreta': 'print',
    },
    {
      'pergunta': 'Em python para ver o tamanho de uma lista usamos?',
      'codigo': 'lista = ["maça","banana","uva"]',
      'respostaCorreta': 'length',
    },
    // Adicione mais perguntas conforme necessário
  ];

  void validarResposta() {
    if (respostaUsuario.toLowerCase() ==
        listaPerguntas[perguntaAtual - 1]['respostaCorreta']) {
      _exibirFeedback(true);
      setState(() {
        appBarColor = Colors.green; // Muda a cor da AppBar para verde
        acertou = true;
        respostaUsuario = ''; // Limpa a resposta do usuário
        _textEditingController.clear(); // Limpa o TextField
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          appBarColor = Colors.blue;
          acertou = false;
        });
      });

      // Avança para a próxima pergunta
      if (perguntaAtual < listaPerguntas.length) {
        perguntaAtual++;
      } else {
        // Se todas as perguntas foram respondidas, pode implementar algo aqui, como exibir uma mensagem de conclusão.
      }
    } else {
      _exibirFeedback(false);
      setState(() {
        appBarColor = Colors.red; // Muda a cor da AppBar para vermelho
      });

      // Restaura a cor para azul após 3 segundos
      Timer(const Duration(seconds: 3), () {
        setState(() {
          appBarColor = Colors.blue;
        });
      });
    }
  }

  void _exibirFeedback(bool acertou) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(acertou ? 'Resposta Correta!' : 'Resposta Incorreta!'),
        backgroundColor: acertou ? Colors.green : Colors.red,
      ),
    );
  }

  void _exibirResposta() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resposta Correta:'),
          content: Text(listaPerguntas[perguntaAtual - 1]['respostaCorreta']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(respostaCorreta);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: acertou ? const Text('Acertou!') : Text('Quiz App - Pergunta $perguntaAtual'),
        backgroundColor: appBarColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            listaPerguntas[perguntaAtual - 1]['pergunta'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              Text(
                listaPerguntas[perguntaAtual - 1]['codigo'],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                // Ajuste o tamanho conforme necessário
                child: TextField(
                  controller: _textEditingController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        respostaCorreta.length), // Limite de caracteres
                  ],
                  onChanged: (value) {
                    setState(() {
                      respostaUsuario = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  validarResposta();
                },
                child: const Text('Validar Resposta'),
              ),
              ElevatedButton(
                onPressed: () {
                  _exibirResposta();
                },
                child: const Text('Ver Resposta'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
