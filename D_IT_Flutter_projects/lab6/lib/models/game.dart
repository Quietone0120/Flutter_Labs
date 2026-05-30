class Game {
  final int id;
  final String title;
  final int price;
  final String imageUrl;

  Game({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  Game copyWith({int? id, String? title, int? price, String? imageUrl}) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
