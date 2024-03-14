import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Counter app'),
          backgroundColor: Colors.greenAccent,
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(children: [
              Text('current value => ${state.value}'),
              Visibility(
                visible: (state is CounterStateInvalidNumber),
                child: Text('Invalid Input: $invalidValue'),
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter the number',
                ),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      },
                      child: const Text('-')),
                  TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      },
                      child: const Text('+')),
                ],
              )
            ]);
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(super.value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(super.value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(super.value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer != null) {
        emit(CounterStateValid(state.value + integer));
      } else {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer != null) {
        emit(CounterStateValid(state.value - integer));
      } else {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      }
    });
  }
}
