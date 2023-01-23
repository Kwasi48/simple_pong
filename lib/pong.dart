import 'package:flutter/material.dart';
import './ball.dart';
import './bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController controller;
  // width and height represents the available space on the screen.
  late double width;
  late double height;
  // posY and posX represents the  vertical and horizontal position of
  //the ball
  double posX = 0;
  double posY = 0;

  ///batHeight and batWidth represent the size poof the bat
  double batWidth = 0;
  double batheight = 0;

  ///bat Position : the position of the bat
  double batPosition = 0;
  double increment = 5;
  //random variables for vertical and horizontal directions
  double randX = 1;
  double randY = 1;
  // score variable
  int score = 0;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 5;
      batheight = height / 20;
      return Stack(
        children: [
          Positioned(
              top: 0, right: 24, child: Text("Score: $score")),
          Positioned(
            top: posY,
            left: posX,
            child: Ball(),
          ),
          Positioned(
            bottom: 0,
            left: batPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails update) =>
                  moveBat(update),
              child: Bat(batWidth, batheight),
            ),
          )
        ],
      );
    });
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - diameter - batheight && vDir == Direction.down) {
      // check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState((){
          score ++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    //this is a number between 0.5 and 1.5;
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context){
    return  AlertDialog(
      title: Text('Game Over'),
      content: Text('Would you like to paly again?'),
      actions: [
        TextButton(
            onPressed: () {
              setState(() {
                posY = 0;
                posX = 0;
                score = 0;
              });
              Navigator.of(context).pop();
              controller.repeat();
            },
            child: Text("Yes")),
        TextButton(
            onPressed: (){
              Navigator.of(context).pop();
              dispose();
            },
            child: Text("No"))
      ],
    );
      });}

}
