import 'package:flutter/material.dart';
import 'dart:math';

import 'package:puzzel/widget/customshape.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  ColorGame({Key key}) : super(key: key);

  createState() => ColorGameState();
}

class ColorGameState extends State<ColorGame> {
  
  final Map<String, bool> score = {};

  /// Choices for game
  final Map choices = {
    '🦚': Colors.green,
    '🐥': Colors.yellow,
    '🐙': Colors.pink[900],
    '🦄': Colors.purple,
    '🦉': Colors.brown,
    '🦞': Colors.orange[700]
  };

  // Random seed to shuffle order of items.
  int seed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: CustomShapeBorder(),
          title: Text('Puzzel Game!!\nScore ${score.length} / 6'
          ,
          style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
          centerTitle: true,
          backgroundColor: Colors.red[900]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red[900],
        child: Icon(Icons.refresh,color: Colors.black,),
        onPressed: () {
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      
      body: 
      Container(
         decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
              Colors.black.withOpacity(0.5),
              Colors.transparent,
              Colors.transparent,
              Colors.black,
            ])),
             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: choices.keys.map((emoji) {
                  return Draggable<String>(
                    data: emoji,
                    child: Emoji(emoji: score[emoji] == true ? ' 😍' : emoji),
                    feedback: Emoji(emoji: emoji),
                    childWhenDragging: Emoji(emoji: ' 🤪'),
                  );
                }).toList()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                    ..shuffle(Random(seed)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List rejected) {
        if (score[emoji] == true) {
          return Container(
          //   decoration: BoxDecoration(
          //  shape: BoxShape.rectangle),
            color: Colors.blueGrey,
            child: Text('Correct ✔️'),
            alignment: Alignment.center,
            height: 25,
            width: 80,
          );
        } else {
          return Container(
          //   decoration: BoxDecoration(
          //  shape: BoxShape.rectangle,),
           color: choices[emoji], height: 20, width: 80);
        }
      },
      onWillAccept: (data) => data == emoji,
      
     onAccept: (data) {
        setState(() {
          score[emoji] = true;
         
        });
      },
    );
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key key, this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 90,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
      ),
    );
  }
}

