import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 250, 159, 152)).copyWith(primary: Color.fromARGB(255, 250, 159, 152)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
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
  String _input = '';
  double _result = 0;
  bool _hasError = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (_hasError) {
        // If there is an error, clear it and start over
        _input = '';
        _hasError = false;
      }

      if (value == '=') {
        try {
          _result = evalExpression(_input);
          _input = _formatResult(_result);
        } catch (e) {
          _input = 'Error';
          _hasError = true;
        }
      } else if (value == 'C') {
        _input = '';
        _result = 0;
        _hasError = false;
      } else if (value == 'Del') {
        // Remove the last character
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        _input += value;
      }
    });
  }

  String _formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(2);
    }
  }

  double evalExpression(String expression) {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align to the top
        children: <Widget>[
          SizedBox(height: 10), // Add space between the AppBar and the text
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _input,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          SizedBox(height: 10), // Add space between the text and the rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCalculatorButton('7'),
              _buildCalculatorButton('8'),
              _buildCalculatorButton('9'),
              _buildCalculatorButton('/'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCalculatorButton('4'),
              _buildCalculatorButton('5'),
              _buildCalculatorButton('6'),
              _buildCalculatorButton('*'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCalculatorButton('1'),
              _buildCalculatorButton('2'),
              _buildCalculatorButton('3'),
              _buildCalculatorButton('-'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCalculatorButton('0'),
              _buildCalculatorButton('C'),
              _buildCalculatorButton('+'),
            ],
          ),
          SizedBox(height: 10), // Add space between the rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCalculatorButton('.'),
              _buildCalculatorButton('%'),
              _buildCalculatorButton('='),
              _buildCalculatorButton('Del'),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildCalculatorButton(String label) {
  return RawMaterialButton(
    onPressed: () => _onButtonPressed(label),
    shape: label == 'Del' || label == '=' ? CircleBorder() : CircleBorder(),
    fillColor: label == 'Del' ? Color.fromARGB(255, 136, 58, 53) : Theme.of(context).colorScheme.primary,
    padding: EdgeInsets.all(24.0),
    child: Text(
      label,
      style: TextStyle(fontSize: 24, color: label == 'Del' ? Colors.white : null),
    ),
  );
}
}
