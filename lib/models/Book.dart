class Book {
  final int id;
  final String name;
  final String author;
  final String genre;
  final String stateOfBook;
  final String description;
  final String location;
  final bool isAskida;
  final String bookImage;
  final String createdBy;
  final String created;
  final String? lastModifiedBy;
  final String? lastModified;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.genre,
    required this.stateOfBook,
    required this.description,
    required this.location,
    required this.isAskida,
    required this.bookImage,
    required this.createdBy,
    required this.created,
    this.lastModifiedBy,
    this.lastModified,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      genre: json['genre'],
      stateOfBook: json['stateOfBook'],
      description: json['description'],
      location: json['location'],
      isAskida: json['isAskida'],
      bookImage: json['bookImage'],
      createdBy: json['createdBy'],
      created: json['created'],
      lastModifiedBy: json['lastModifiedBy'],
      lastModified: json['lastModified'],
    );
  }
}
