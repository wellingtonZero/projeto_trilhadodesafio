import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  String _displayText = '';

  void _updateText() {
    setState(() {
      _displayText = _textEditingController.text;
      _textEditingController.clear(); // Limpa o conteúdo do TextField
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Textfield App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Digite algo...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateText();
              },
              child: const Text('OK'),
            ),
            const SizedBox(height: 20),
            Text(
              'Texto inserido: $_displayText',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
