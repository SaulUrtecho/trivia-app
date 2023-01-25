import 'package:clean_architecture_tdd_course/presentation/pages/trivia_page.dart';
import 'package:flutter/material.dart';
import 'dependency_injection/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // for to link with flutter engine layer
  await di.init(); // call the method for dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade800),
      ),
      home: const TriviaPage(),
    );
  }
}
