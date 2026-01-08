import 'dart:math';

class PuzzleController {
  final int size;
  List<int> tiles;
  int emptyIndex;

  PuzzleController({this.size = 4})
      : tiles = List.generate(size * size, (index) => index),
        emptyIndex = (size * size) - 1 {
    shuffle();
  }

  void shuffle() {
    final Random random = Random();
    // To ensure solvability, we can perform random valid moves
    for (int i = 0; i < 1000; i++) {
      List<int> neighbors = _getNeighbors(emptyIndex);
      int nextIndex = neighbors[random.nextInt(neighbors.length)];
      _swap(emptyIndex, nextIndex);
      emptyIndex = nextIndex;
    }
  }

  bool move(int index) {
    if (_isAdjacent(index, emptyIndex)) {
      _swap(index, emptyIndex);
      emptyIndex = index;
      return true;
    }
    return false;
  }

  bool isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i) return false;
    }
    return true;
  }

  bool _isAdjacent(int idx1, int idx2) {
    int r1 = idx1 ~/ size;
    int c1 = idx1 % size;
    int r2 = idx2 ~/ size;
    int c2 = idx2 % size;
    return (r1 == r2 && (c1 - c2).abs() == 1) || (c1 == c2 && (r1 - r2).abs() == 1);
  }

  List<int> _getNeighbors(int index) {
    List<int> neighbors = [];
    int r = index ~/ size;
    int c = index % size;

    if (r > 0) neighbors.add((r - 1) * size + c);
    if (r < size - 1) neighbors.add((r + 1) * size + c);
    if (c > 0) neighbors.add(r * size + (c - 1));
    if (c < size - 1) neighbors.add(r * size + (c + 1));

    return neighbors;
  }

  void _swap(int idx1, int idx2) {
    int temp = tiles[idx1];
    tiles[idx1] = tiles[idx2];
    tiles[idx2] = temp;
  }
}
