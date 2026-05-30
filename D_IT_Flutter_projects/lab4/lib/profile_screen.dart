import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThunderZ Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 0, 0, 0), // accent orange/red-ish
          surface: Color.fromARGB(255, 255, 253, 253),
        ),
        cardColor: const Color.fromARGB(255, 0, 0, 0),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyMedium: TextStyle(color: Color.fromARGB(179, 12, 1, 1)),
        ),
      ),
      home: const ArtistProfileScreen(),
    );
  }
}

class ArtistProfileScreen extends StatelessWidget {
  const ArtistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header / SliverAppBar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient or image (та өөрийн image тавьж болно)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1A1A2E), Color(0xFF0F0F0F)],
                      ),
                    ),
                  ),
                  // Profile content
                  Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Profile picture (circle avatar)
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 3),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'assets/Profilephoto.png', // өөрийн зураг URL
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'THUNDERZ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.music_note,
                              size: 16,
                              color: Color.fromARGB(179, 255, 255, 255),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'ARTIST',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  127,
                                  133,
                                  128,
                                ).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '✓ Монгол',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: const [
              Icon(Icons.notifications_none),
              SizedBox(width: 16),
              Icon(Icons.search),
              SizedBox(width: 16),
              Icon(Icons.settings),
              SizedBox(width: 16),
            ],
          ),

          // Stats row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Posts', '139'),
                  _buildStat('Followers', '309K'),
                  _buildStat('Following', '645'),
                ],
              ),
            ),
          ),

          // Buttons row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Following'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined, size: 18),
                      label: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Icons row (headphones, lock/music, camera)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.headphones, 'Сонсох'),
                  _buildIconButton(Icons.lock_outline, 'Хувийн'),
                  _buildIconButton(Icons.camera_alt, 'Зураг'),
                ],
              ),
            ),
          ),

          // Секцүүд
          _buildSectionTitle('Сүүлчийн топ дуунууд'),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSongTile(
                'Tengri: GEGEN (ft. Ninjin )',
                '7:45',
                image: 'assets/song1.png',
              ),
              _buildSongTile(
                'Togtuun - Uzesgelengoo',
                '2:53',
                image: 'assets/song2.png',
              ),
              _buildSongTile(
                'mxrnningstar - бодлын гүнээс',
                '3:59',
                image: 'assets/song3.png ',
              ),
            ]),
          ),
          _buildSectionTitle('Таны дуунууд'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildHorizontalCard('Thunder - Tengri: MONGOL', '43', '1m'),
                  _buildHorizontalCard('Tengri: GEGEN', '8k', '8.4m'),
                  _buildHorizontalCard('Tengri: Heer Mori', '1k', '2.9m'),
                ],
              ),
            ),
          ),

          _buildSectionTitle('Сонсох дуртай дуунууд'),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  // Та энд 3-4 зураг тавьж болно (placeholder)
                  PlaceholderCard(title: 'Marv - Wololo'),
                  PlaceholderCard(title: 'Tengri - p'),
                  PlaceholderCard(title: 'FIYOS'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ), // bottom padding
        ],
      ),

      // Bottom Navigation (optional)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F0F0F),
        selectedItemColor: const Color(0xFFFF3D00),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '+',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 4,
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: const Color.fromARGB(179, 5, 2, 2)),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSongTile(
    String title,
    String duration, {
    required String image,
  }) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(duration, style: const TextStyle(color: Colors.white54)),
      trailing: const Icon(Icons.favorite_border, color: Colors.white70),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildHorizontalCard(String title, String plays, String likes) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.album, size: 50, color: Colors.white30),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13)),
          Text(
            '$plays • $likes',
            style: const TextStyle(fontSize: 11, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

// Placeholder widget for horizontal cards
class PlaceholderCard extends StatelessWidget {
  final String title;

  const PlaceholderCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.play_arrow, size: 60, color: Colors.white54),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
