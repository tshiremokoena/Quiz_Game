import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScoresScreen extends StatefulWidget {
  @override
  State<HighScoresScreen> createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  final List<String> categories = ['Wonders','Animals','Flags','Space','History','Mixed'];
  Map<String,int> highs = {};

  @override
  void initState() {
    super.initState();
    _loadHighs();
  }

  Future<void> _loadHighs() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String,int> m = {};
    for (var c in categories) {
      m[c] = prefs.getInt('highscore_\$c') ?? 0;
    }
    setState(() => highs = m);
  }

  Future<void> _clearHighs() async {
    final prefs = await SharedPreferences.getInstance();
    for (var c in categories) await prefs.remove('highscore_\$c');
    await _loadHighs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal, Colors.indigo])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('High Scores', style: GoogleFonts.poppins(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w600)),
                    IconButton(icon: Icon(Icons.delete, color: Colors.white), onPressed: () async { await _clearHighs(); }),
                  ],
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (_, i) {
                      final c = categories[i];
                      final score = highs[c] ?? 0;
                      return Card(
                        color: Colors.white10,
                        child: ListTile(
                          title: Text(c, style: GoogleFonts.poppins(color: Colors.white)),
                          trailing: Text('\$score', style: GoogleFonts.poppins(color: Colors.white70)),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
