// ignore_for_file: sized_box_for_whitespace

import 'package:clean_architecture_tdd_course/dependency_injection/di.dart';
import 'package:clean_architecture_tdd_course/presentation/bloc/trivia_bloc.dart';
import 'package:clean_architecture_tdd_course/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaPage extends StatelessWidget {
  const TriviaPage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trivia App by RESO CODER')),
      // we wrap with a singlechild to avoid a overflow in the ui
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  // method for provide the bloc in the tree
  BlocProvider<TriviaBloc> buildBody(context) {
    return BlocProvider(
      create: (_) => getIt<TriviaBloc>(), // bloc injection
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<TriviaBloc, TriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(trivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 10),
              const TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
