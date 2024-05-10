class Wishlist {
  final int id;
  final String name;
  final String author;
  final String stateOfBook;
  final String description;
  final String createdBy;
  final DateTime created;


  Wishlist({
    required this.id,
    required this.name,
    required this.author,
    required this.stateOfBook,
    required this.description,
    required this.createdBy,
    required this.created,

  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      stateOfBook: json['stateOfBook'],
      description: json['description'],
      createdBy: json['createdBy'],
      created: DateTime.parse(json['created']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'author': author,
      'stateOfBook': stateOfBook,
      'description': description,
      'createdBy': createdBy,
      'created': created.toIso8601String(),

    };
  }
}

