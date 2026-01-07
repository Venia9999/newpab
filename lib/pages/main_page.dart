import 'package:flutter/material.dart';
import 'home_page.dart';
import 'film_page.dart';
import 'history_list_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  final String userName;

  const MainPage({super.key, required this.userName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomePage(userName: widget.userName),    // 🏠 Beranda
      const FilmPage(),                       // 🎬 Film
      const HistoryListPage(),                // 🧾 Riwayat
      ProfilePage(userName: widget.userName), // 👤 Akun
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0A1F44),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: "Film",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Riwayat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Akun",
          ),
        ],
      ),
    );
  }
}
