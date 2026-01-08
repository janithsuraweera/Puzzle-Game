import 'package:flutter/material.dart';
import 'package:sliding_puzzle/models/puzzle_engine.dart';
import 'package:sliding_puzzle/widgets/glass_tile.dart';

void main() {
  runApp(const SlidingPuzzleApp());
}

class SlidingPuzzleApp extends StatelessWidget {
  const SlidingPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Sliding Puzzle',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  PuzzlePageState createState() => PuzzlePageState();
}

class PuzzlePageState extends State<PuzzlePage> {
  late PuzzleController _controller;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _controller = PuzzleController(size: 4);
  }

  void _handleTileTap(int index) {
    setState(() {
      if (_controller.move(index)) {
        _moves++;
        if (_controller.isSolved()) {
          _showWinDialog();
        }
      }
    });
  }

  void _resetGame() {
    setState(() {
      _controller.shuffle();
      _moves = 0;
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You solved the puzzle in $_moves moves!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Sliding Puzzle',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Moves: $_moves',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double boardSize = constraints.maxWidth;
                          double tileSize = boardSize / _controller.size;

                          return Stack(
                            children: List.generate(_controller.tiles.length, (
                              index,
                            ) {
                              int tileValue = _controller.tiles[index];
                              if (tileValue ==
                                  (_controller.size * _controller.size) - 1) {
                                return const SizedBox.shrink();
                              }

                              // Find the position of this tileValue in the tiles list
                              int currentIndex = _controller.tiles.indexOf(
                                tileValue,
                              );
                              int r = currentIndex ~/ _controller.size;
                              int c = currentIndex % _controller.size;

                              return AnimatedPositioned(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutBack,
                                left: c * tileSize,
                                top: r * tileSize,
                                width: tileSize,
                                height: tileSize,
                                child: GlassTile(
                                  value: tileValue,
                                  isEmpty: false,
                                  onTap: () => _handleTileTap(currentIndex),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: const Text(
                    'RESTART',
                    style: TextStyle(color: Colors.white, letterSpacing: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
