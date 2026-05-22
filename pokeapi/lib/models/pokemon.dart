class Pokemon {

  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
      height: json['height'],
      weight: json['weight'],
    );
  }
}