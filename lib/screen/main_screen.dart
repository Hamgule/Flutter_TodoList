import 'package:flutter/material.dart';
import 'package:todolist/config/palette.dart';

import 'list_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MainBackground(),
        ),
      ),
    );
  }
}

class MainBackground extends StatelessWidget {
  const MainBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TodolistLogo(),
    );
  }
}

// Todolist 로고
class TodolistLogo extends StatefulWidget {
  const TodolistLogo({Key? key}) : super(key: key);

  @override
  _TodolistLogoState createState() => _TodolistLogoState();
}

class _TodolistLogoState extends State<TodolistLogo> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'TODO',
            style: TextStyle(
              color: Palette.textColor1,
              fontFamily: 'MontserratBold',
              fontSize: 80.0,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(5.0, 5.0),
                  blurRadius: 10.0,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          Text(
            ' LIST',
            style: TextStyle(
              color: Palette.textColor2,
              fontFamily: 'MontserratBold',
              fontSize: 80.0,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(5.0, 5.0),
                  blurRadius: 10.0,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)
                => const ListScreen(),
            ),
          );
        });
      },
    );
  }
}
