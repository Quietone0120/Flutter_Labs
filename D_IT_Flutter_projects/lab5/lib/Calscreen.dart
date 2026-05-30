import 'package:flutter/material.dart';

class Calscreen extends StatefulWidget {
  @override
  _CalScreenState createState() => _CalScreenState();
}

class _CalScreenState extends State<Calscreen> {
  String display = "0";
  List<String> history = [];

  double num1 = 0;
  double num2 = 0;
  String operator = "";

  void buttonPressed(String value) {
    setState(() {
      if (value == "CLEAR") {
        display = "0";
      } else if (value == "+" || value == "-" || value == "*" || value == "/") {
        num1 = double.parse(display);
        operator = value;
        display = "0";
      } else if (value == "=") {
        num2 = double.parse(display);
        double result = 0;

        if (operator == "+") result = num1 + num2;
        if (operator == "-") result = num1 - num2;
        if (operator == "*") result = num1 * num2;
        if (operator == "/") result = num1 / num2;

        history.add("$num1 $operator $num2 = $result");

        display = result.toStringAsFixed(2);
      } else if (value == ".") {
        if (!display.contains(".")) {
          display += ".";
        }
      } else {
        if (display == "0")
          display = value;
        else
          display += value;
      }
    });
  }

  Widget calcButton(String text) {
    bool isOperator =
        text == "+" || text == "-" || text == "*" || text == "/" || text == "=";

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator
                ? Colors.orange
                : const Color.fromARGB(255, 31, 24, 58),
          ),
          onPressed: () {
            buttonPressed(text);
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Calculator"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history', arguments: history);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(20),
            child: Text(
              display,
              style: TextStyle(fontSize: 60, color: Colors.white),
            ),
          ),

          Spacer(
            flex: 25,
          ), // энэ display ба button хооронд зай авч button-уудыг доош түлхэнэ

          Column(
            children: [
              Row(
                children: [
                  calcButton("7"),
                  calcButton("8"),
                  calcButton("9"),
                  calcButton("/"),
                ],
              ),

              Row(
                children: [
                  calcButton("4"),
                  calcButton("5"),
                  calcButton("6"),
                  calcButton("*"),
                ],
              ),

              Row(
                children: [
                  calcButton("1"),
                  calcButton("2"),
                  calcButton("3"),
                  calcButton("-"),
                ],
              ),

              Row(
                children: [
                  calcButton("0"),
                  calcButton("."),
                  calcButton("00"),
                  calcButton("+"),
                ],
              ),

              Row(children: [calcButton("CLEAR"), calcButton("=")]),
            ],
          ),
        ],
      ),
    );
  }
}
