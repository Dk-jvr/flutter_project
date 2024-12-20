class Beer {
  final int id;
  final String name;
  String description;
  final double price;
  final String image;

  Beer({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }

  static List<Beer> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Beer.fromJson(json)).toList();
  }
}
