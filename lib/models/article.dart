class Article {
  final String title;
  final String url;
  final String image;

  Article({
    required this.title,
    required this.url,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      image: json['urlToImage'] ??
          'https://via.placeholder.com/400x200',
    );
  }
}
