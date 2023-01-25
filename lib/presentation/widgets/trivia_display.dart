// ignore_for_file: sized_box_for_whitespace

import 'package:clean_architecture_tdd_course/domain/entities/trivia_entity.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final Trivia trivia;
  const TriviaDisplay({super.key, required this.trivia});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  trivia.text,
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
