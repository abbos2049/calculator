import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorUI(),
    );
  }
}

class CalculatorUI extends StatefulWidget {
  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
      } else if (value == 'CE') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _calculateResult();
      } else {
        _expression += value;
      }
    });
  }

  void _calculateResult() {
    try {
      String finalExpression = _expression;
      finalExpression = finalExpression.replaceAll('×', '*');
      finalExpression = finalExpression.replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        _result = (eval == eval.toInt() ? eval.toInt().toString() : eval.toString());
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  Widget _buildButton(String text,
      {Color textColor = Colors.black, Color bgColor = Colors.transparent, double size = 24, bool isOperator = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onButtonPressed(text),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(isOperator ? 20 : 20),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'A simple calculator app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Buttons
            Divider(height: 1),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', textColor: Colors.black, bgColor: Colors.grey.shade300),
                    _buildButton('CE', textColor: Colors.black, bgColor: Colors.grey.shade300),
                    _buildButton('%', textColor: Colors.black, bgColor: Colors.grey.shade300),
                    _buildButton('÷', textColor: Colors.white, bgColor: Colors.red, isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', textColor: Colors.white, bgColor: Colors.red, isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', textColor: Colors.white, bgColor: Colors.red, isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', textColor: Colors.white, bgColor: Colors.red, isOperator: true),
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 1, child: SizedBox()), // Empty space for alignment
                    _buildButton('0'),
                    Expanded(flex: 1, child: SizedBox()), // Empty space for alignment
                    _buildButton('=', textColor: Colors.white, bgColor: Colors.red, isOperator: true),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
