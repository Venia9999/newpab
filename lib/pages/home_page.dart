import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/movie.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../services/news_service.dart';
import '../pages/detail_movie_page.dart';
import '../pages/notification_page.dart'; // ✅ TAMBAHAN

class HomePage extends StatelessWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const _HomeContent(),
    );
  }
}

// ================= HOME CONTENT =================
class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  static const Color gold = Color(0xFFD4AF37);

  final List<String> bannerAssets = [
    "assets/banner/promo1.jpg",
    "assets/banner/promo2.jpg",
    "assets/banner/promo3.jpg",
  ];

  late PageController promoController;
  late PageController spotlightController;

  Timer? promoTimer;
  Timer? spotlightTimer;

  int promoIndex = 0;
  int spotlightIndex = 0;

  final TextEditingController searchCtrl = TextEditingController();
  List<Movie> allMovies = [];
  List<Movie> filteredMovies = [];

  @override
  void initState() {
    super.initState();
    promoController = PageController(viewportFraction: 0.95);
    spotlightController = PageController(viewportFraction: 0.9);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      promoIndex = (promoIndex + 1) % bannerAssets.length;
      promoController.animateToPage(
        promoIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });

    spotlightTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      spotlightIndex = (spotlightIndex + 1) % 10;
      spotlightController.animateToPage(
        spotlightIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    promoTimer?.cancel();
    spotlightTimer?.cancel();
    promoController.dispose();
    spotlightController.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  void _searchMovie(String value) {
    setState(() {
      filteredMovies = value.isEmpty
          ? allMovies
          : allMovies
              .where((m) =>
                  m.title.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: ApiService.getMovies(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        allMovies = snap.data!;
        if (filteredMovies.isEmpty) filteredMovies = allMovies;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Lotte Cinema XXI",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: gold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Sungailiat · Bangka Belitung",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    // 🔔 NOTIFIKASI (SUDAH FIX)
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_rounded,
                        color: gold,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ================= SEARCH =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchCtrl,
                  onChanged: _searchMovie,
                  decoration: InputDecoration(
                    hintText: "Cari Film...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= PROMO AUTO SLIDE =================
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: promoController,
                  itemCount: bannerAssets.length,
                  itemBuilder: (_, i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(bannerAssets[i]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= SEDANG TAYANG =================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Sedang Tayang",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: filteredMovies.length,
                  itemBuilder: (_, i) {
                    final m = filteredMovies[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailMoviePage(movie: m),
                        ),
                      ),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                m.poster,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ================= SPOTLIGHT =================
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Spotlight",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              FutureBuilder<List<Article>>(
                future: NewsService.getNews(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final news = snap.data!;
                  return SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: spotlightController,
                      itemCount: news.length,
                      itemBuilder: (_, i) {
                        final a = news[i];
                        return GestureDetector(
                          onTap: () => _openUrl(a.url),
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(a.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black87,
                                  ],
                                ),
                              ),
                              child: Text(
                                a.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
