class Movie {
  final int id;
  final String title;
  final String description;
  final String poster;
  final String tailer; // dari kolom tailer
  final int duration;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.poster,
    required this.tailer,
    required this.duration,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      description: json['description'],
      poster: json['poster'],
      tailer: json['tailer'], // ⬅️ SESUAI DATABASE
      duration: int.parse(json['duration'].toString()),
    );
  }
}
