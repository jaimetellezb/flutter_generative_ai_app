import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

String? apiKey = 'API_KEY';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Generative AI'),
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
  bool _isLoading = false;
  late GenerativeModel _model;
  String? _text = '';
  final TextEditingController _textController = TextEditingController();

  void _generateContent() async {
    final content = [Content.text(_textController.text)];
    setState(() {
      _isLoading = true;
    });
    final response = await _model.generateContent(content);

    _text = response.text;
    _textController.clear();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Escribe algo...',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _textController,
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: _generateContent,
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          '$_text',
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
