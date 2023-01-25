import 'package:clean_architecture_tdd_course/presentation/bloc/trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  // we create controller for manage the behavior in the Textfield
  final controller = TextEditingController();
  // here we save the str which will be convert a int value
  late String inputStr;

  @override
  Widget build(context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
          // send the event from keyboard
          onSubmitted: (_) {
            controller.clear();
            context.read<TriviaBloc>().add(GetTriviaByNumber(inputStr));
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green.shade800)),
                onPressed: () {
                  // once that button is pressed the textfield is cleared
                  // and same time the event is added to the bloc
                  controller.clear();
                  context.read<TriviaBloc>().add(GetTriviaByNumber(inputStr));
                },
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                onPressed: () {
                  // once that button is pressed the textfield is cleared
                  // and same time the event for a random trivia is added to the bloc
                  controller.clear();
                  context.read<TriviaBloc>().add(GetTriviaByRandomNumber());
                },
                child: const Text('Get Random Trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
