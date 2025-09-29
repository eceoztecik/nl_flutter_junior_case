class Movie {
  final String id;
  final String title;
  final String? description;
  final String? posterUrl;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    this.description,
    this.posterUrl,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['Title'] ?? json['title'] ?? '',
      description: json['Plot'] ?? json['description'],
      posterUrl: json['Poster'] ?? json['posterUrl'],
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
    };
  }

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, description: $description, posterUrl: $posterUrl, isFavorite: $isFavorite)';
  }
}
