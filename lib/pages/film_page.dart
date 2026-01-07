import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import 'detail_movie_page.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  // 🎨 WARNA SAMA DENGAN HOME
  static const Color gold = Color(0xFFD4AF37);
  static const Color bgWhite = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);

  List<Movie> movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        backgroundColor: bgWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: gold),
        title: const Text(
          "Film",
          style: TextStyle(
            color: gold,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: ApiService.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: gold),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada film tersedia",
                style: TextStyle(color: textSecondary),
              ),
            );
          }

          movies = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailMoviePage(movie: movie),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgWhite,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= POSTER =================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          movie.poster,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ================= INFO =================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Icon(
                                  Icons.local_movies,
                                  size: 16,
                                  color: gold,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Sedang Tayang",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFD4AF37),
                                      Color(0xFFE6C567),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gold.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Detail",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
