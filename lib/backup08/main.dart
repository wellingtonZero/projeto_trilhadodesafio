import 'package:flutter/material.dart';

import 'quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ThemeListScreen(),
    );
  }
}

class ThemeListScreen extends StatelessWidget {
  final List<String> themes = ['String', 'Listas']; // Adicione mais temas conforme necessário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha um tema'),
      ),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(themes[index]),
            onTap: () {
              // Navegue para a tela do quiz relacionada ao tema selecionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(theme: themes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
