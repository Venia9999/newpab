import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/movie.dart';
import 'ticket_page.dart';

class DetailMoviePage extends StatefulWidget {
  final Movie movie;
  const DetailMoviePage({super.key, required this.movie});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  // ================= THEME =================
  static const Color gold = Color(0xFFD4AF37);
  static const Color bg = Color(0xFFF6F6F6);
  static const Color textDark = Color(0xFF333333);

  bool isFavorite = false;
  String selectedJam = "13:00";

  late YoutubePlayerController _ytController;
  bool _hasTrailer = false;

  final List<String> jamTayang = [
    "10:00",
    "13:00",
    "16:00",
    "19:00",
    "21:30",
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorite();

    final videoId =
        YoutubePlayer.convertUrlToId(widget.movie.tailer);

    if (videoId != null) {
      _hasTrailer = true;
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_hasTrailer) {
      _ytController.dispose();
    }
    super.dispose();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('fav_${widget.movie.id}') ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool('fav_${widget.movie.id}', isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: gold,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== POSTER =====
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _box(),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          widget.movie.poster,
                          width: 130,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _infoRow(
                              Icons.schedule,
                              "${widget.movie.duration} menit",
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              Icons.movie,
                              "Sedang Tayang",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ===== JAM TAYANG =====
                const Text(
                  "Pilih Jam Tayang",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: jamTayang.map((jam) {
                    final selected = jam == selectedJam;
                    return ChoiceChip(
                      label: Text(jam),
                      selected: selected,
                      selectedColor: gold,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: gold),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : gold,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) {
                        setState(() => selectedJam = jam);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // ===== DESKRIPSI =====
                const Text(
                  "Deskripsi Film",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _box(),
                  child: Text(
                    widget.movie.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ===== TRAILER (EMBED) =====
                if (_hasTrailer) ...[
                  const Text(
                    "Trailer Film",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: _box(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: YoutubePlayer(
                        controller: _ytController,
                        showVideoProgressIndicator: true,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ===== BUTTON PESAN =====
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TicketPage(
                        movie: widget.movie,
                        selectedJam: selectedJam,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Pesan Tiket",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= UTIL =================
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
        ),
      ],
    );
  }
}
