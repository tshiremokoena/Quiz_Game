import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_screen.dart';
import 'high_scores_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ['Wonders','Animals','Flags','Space','History','Mixed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.indigo, Colors.blueAccent]),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quiz Game', style: GoogleFonts.poppins(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                        ),
                        IconButton(
                          icon: Icon(Icons.leaderboard, color: Colors.white),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HighScoresScreen())),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: categories.map((c) => _buildCard(context, c)).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(category: title))),
      child: Hero(
        tag: title,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.04)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }
}
