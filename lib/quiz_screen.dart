import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizScreen extends StatefulWidget {
  final String theme;

  const QuizScreen({Key? key, required this.theme}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int perguntaAtual = 0;
  String respostaUsuario = '';
  String respostaCorreta = '';
  Color appBarColor = Colors.blue;
  bool acertou = false;

  TextEditingController _textEditingController = TextEditingController();

  // Lista de perguntas e respostas por tema
  Map<String, List<Map<String, dynamic>>> temas = {
    'String': [
      {
        'pergunta': 'Como converter uma int para string',
        'respostaCorreta': 'str',
      },
      {
        'pergunta': 'Complete o código ?????(Hello World!!!)',
        'respostaCorreta': 'print',
      },
      // Adicione mais perguntas sobre String conforme necessário
    ],
    'Listas': [
      {
        'pergunta': 'Como acessar o segundo elemento de uma lista em Dart?',
        'respostaCorreta': 'lista[1]',
      },
      {
        'pergunta': 'Como acessar o terceiro elemento de uma lista em Dart?',
        'respostaCorreta': 'lista[2]',
      },
      // Adicione mais perguntas sobre Listas conforme necessário
    ],
  };

  void validarResposta() {
    if (perguntaAtual < temas[widget.theme]!.length) {
      if (respostaUsuario.toLowerCase() == respostaCorreta.toLowerCase()) {
        _exibirFeedback(true);
        setState(() {
          appBarColor = Colors.green;
          acertou = true;
          respostaUsuario = '';
          _textEditingController.clear();
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            appBarColor = Colors.blue;
            acertou = false;
            perguntaAtual++;
            if (perguntaAtual < temas[widget.theme]!.length) {
              respostaCorreta = temas[widget.theme]![perguntaAtual]['respostaCorreta'];
            } else {
              // Se todas as perguntas foram respondidas, finaliza o quiz
              finalizarQuiz();
            }
          });
        });
      } else {
        _exibirFeedback(false);
        setState(() {
          appBarColor = Colors.red;
        });
        Timer(const Duration(seconds: 3), () {
          setState(() {
            appBarColor = Colors.blue;
            perguntaAtual++;
            if (perguntaAtual < temas[widget.theme]!.length) {
              respostaCorreta = temas[widget.theme]![perguntaAtual]['respostaCorreta'];
            } else {
              // Se todas as perguntas foram respondidas, finaliza o quiz
              finalizarQuiz();
            }
          });
        });
      }
    }
  }

  void finalizarQuiz() {
    // Calcula a pontuação e retorna para a tela anterior
    final acertos = temas[widget.theme]!.where((pergunta) => pergunta['respostaCorreta'] == respostaUsuario).length;
    final pontuacao = {'acertos': acertos, 'total': temas[widget.theme]!.length};
    Navigator.pop(context, pontuacao);
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
          content: Text(respostaCorreta),
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
  void initState() {
    super.initState();
    if (temas.containsKey(widget.theme) && temas[widget.theme]!.isNotEmpty) {
      respostaCorreta = temas[widget.theme]![perguntaAtual]['respostaCorreta'];
    } else {
      // Se não houver perguntas para o tema, finaliza o quiz
      finalizarQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: acertou
            ? const Text('Acertou!')
            : Text('Quiz App - Pergunta ${perguntaAtual + 1}'),
        backgroundColor: appBarColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            perguntaAtual < temas[widget.theme]!.length
                ? temas[widget.theme]![perguntaAtual]['pergunta']
                : '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              Text(
                perguntaAtual < temas[widget.theme]!.length
                    ? temas[widget.theme]![perguntaAtual]['codigo'] ?? ''
                    : '',
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
                child: TextField(
                  controller: _textEditingController,
                  inputFormatters: [
                    if (respostaCorreta.isNotEmpty)
                      LengthLimitingTextInputFormatter(respostaCorreta.length),
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
                onPressed: () => validarResposta(),
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
