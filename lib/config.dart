class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

enum Side { counterTerrorist, terrorist }

class Grenade {
  final Point position;
  final String name;
  final Side side;

  const Grenade({
    required this.position,
    required this.name,
    required this.side,
  });
}

class Map {
  final List<Grenade> grenades;
  final String image;

  const Map({required this.grenades, required this.image});
}
